---
name: exploring-finances
description: Use when user asks about spending, budgets, transactions, categories, or any YNAB/financial data exploration. Use when answering questions like "how much did I spend on X", "show me transactions for Y", "what are my budget categories".
---

# Exploring Finances

Query Peter's personal financial data using the DuckDB warehouse. Prefer warehouse queries over API calls - it's faster and doesn't hit rate limits.

## Quick Reference

| Task | Tool |
|------|------|
| Query transactions, spending, categories | `duckdb` on warehouse |
| Refresh data from YNAB | `python -m warehouse sync ynab` |
| Check sync status | `python -m warehouse status` |
| Get fresh data not in warehouse | `python -m finlib ynab ...` |

## Warehouse Location

```bash
# Default location (from infra repo)
/home/cuiv/dev/infra/apps/warehouse/vars/warehouse.duckdb
```

## Schema

```
raw_ynab.budgets      (budget_id, name, currency_code, last_modified_on)
raw_ynab.accounts     (account_id, budget_id, name, account_type, on_budget, balance, cleared_balance, closed)
raw_ynab.categories   (category_id, budget_id, category_group_id, category_group_name, name, hidden)
raw_ynab.payees       (payee_id, budget_id, name, transfer_account_id)
raw_ynab.transactions (transaction_id, budget_id, account_id, date, amount, payee_id, payee_name, category_id, category_name, memo, cleared, approved, deleted)
```

**Key notes:**
- `amount` is in dollars (already converted from milliunits)
- Negative amounts = outflows (spending), positive = inflows
- `deleted=true` means soft-deleted in YNAB
- Join on `budget_id` when querying across tables

## Common Queries

**Monthly spending by category:**
```sql
SELECT
    category_name,
    strftime(date, '%Y-%m') as month,
    SUM(amount) as total
FROM raw_ynab.transactions
WHERE amount < 0 AND deleted = false
GROUP BY category_name, month
ORDER BY month DESC, total ASC;
```

**Spending at a payee:**
```sql
SELECT date, amount, category_name, memo
FROM raw_ynab.transactions
WHERE payee_name ILIKE '%costco%'
  AND deleted = false
ORDER BY date DESC;
```

**Uncategorized transactions:**
```sql
SELECT date, payee_name, amount, memo
FROM raw_ynab.transactions
WHERE category_id IS NULL
  AND deleted = false
  AND amount < 0
ORDER BY date DESC;
```

**Account balances:**
```sql
SELECT name, account_type, balance, cleared_balance
FROM raw_ynab.accounts
WHERE closed = false
ORDER BY balance DESC;
```

## When to Use finlib CLI

Use `finlib` directly when:
- Data might have changed since last sync
- Need real-time balance or recent transactions
- Exploring data not yet synced

```bash
# List budgets
python -m finlib ynab budgets

# Recent transactions (last 30 days)
python -m finlib ynab transactions <budget_id> --since 2024-01-01

# Uncategorized transactions
python -m finlib ynab transactions <budget_id> --uncategorized
```

## Workflow

1. **Start with warehouse** - fast, no API calls
2. **If data seems stale** - run `python -m warehouse sync ynab`
3. **For real-time needs** - use `python -m finlib ynab ...`

## Running Queries

**Via duckdb CLI (preferred for exploration):**
```bash
duckdb /home/cuiv/dev/infra/apps/warehouse/vars/warehouse.duckdb
```

**Via warehouse CLI:**
```bash
cd /home/cuiv/dev/infra && python -m warehouse query "SELECT * FROM raw_ynab.accounts LIMIT 5"
```
