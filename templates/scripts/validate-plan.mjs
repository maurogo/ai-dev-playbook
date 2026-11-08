#!/usr/bin/env node
// validate-plan.mjs — dependency-free structural check for docs/*-plan.json files.
// Usage: node validate-plan.mjs <plan.json> [more.json ...]
import { readFileSync } from "node:fs";

const STATUSES = new Set(["not-started", "in-progress", "blocked", "completed"]);
const LIFECYCLES = new Set(["single-pr", "multi-session"]);
const DATE = /^\d{4}-\d{2}-\d{2}$/;

/** Validate one plan object and return a list of error strings. */
function validate(plan) {
  const errors = [];
  const req = (cond, msg) => { if (!cond) errors.push(msg); };

  req(typeof plan.planId === "string" && plan.planId.length > 0, "planId: required string");
  req(typeof plan.title === "string", "title: required string");
  req(LIFECYCLES.has(plan.lifecycle), `lifecycle: one of ${[...LIFECYCLES].join(", ")}`);
  req(DATE.test(plan.createdDate ?? ""), "createdDate: YYYY-MM-DD");
  req(DATE.test(plan.lastUpdated ?? ""), "lastUpdated: YYYY-MM-DD");
  req(Array.isArray(plan.workItems) && plan.workItems.length > 0, "workItems: non-empty array");

  const ids = new Set();
  (plan.workItems ?? []).forEach((item, i) => {
    const at = `workItems[${i}]`;
    req(typeof item.id === "string", `${at}.id: required string`);
    req(!ids.has(item.id), `${at}.id: duplicate "${item.id}"`);
    ids.add(item.id);
    req(STATUSES.has(item.status), `${at}.status: one of ${[...STATUSES].join(", ")}`);
    req(Array.isArray(item.log), `${at}.log: array`);
    (item.log ?? []).forEach((entry, j) => {
      req(DATE.test(entry.date ?? ""), `${at}.log[${j}].date: YYYY-MM-DD`);
      req(typeof entry.summary === "string", `${at}.log[${j}].summary: required string`);
    });
    (item.dependsOn ?? []).forEach((dep) =>
      req((plan.workItems ?? []).some(({ id }) => id === dep), `${at}.dependsOn: unknown id "${dep}"`),
    );
  });

  req(Array.isArray(plan.changelog), "changelog: array");
  const allDone = (plan.workItems ?? []).every(({ status }) => status === "completed");
  if (plan.status === "completed") req(allDone, "status completed but some workItems are not");
  return errors;
}

const files = process.argv.slice(2);
if (files.length === 0) {
  console.error("usage: validate-plan.mjs <plan.json> [...]");
  process.exit(2);
}

let failed = false;
for (const file of files) {
  try {
    const errors = validate(JSON.parse(readFileSync(file, "utf8")));
    if (errors.length) {
      failed = true;
      console.error(`✗ ${file}`);
      errors.forEach((e) => console.error(`  - ${e}`));
    } else {
      console.log(`✓ ${file}`);
    }
  } catch (error) {
    failed = true;
    console.error(`✗ ${file}: ${error.message}`);
  }
}
process.exit(failed ? 1 : 0);
