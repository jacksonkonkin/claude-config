---
name: notion-todo
description: "Add, view, and manage to-do items in a Notion database. Use this skill whenever the user wants to add a task, create a to-do, check off an item, list their tasks, or manage any kind of personal to-do list. Trigger on phrases like 'add to my to-do list', 'remind me to', 'I need to', 'what's on my list', 'mark X as done', 'show my tasks', or any mention of todos, tasks, or action items the user wants tracked. Even casual mentions like 'oh I should remember to...' or 'don't let me forget to...' should trigger this skill."
---

# Notion To-Do List Manager

This skill lets users manage a personal to-do list stored in Notion. Items have a title, optional due date, optional notes, optional tags, and pipeline tracking columns for feature development workflows.

## How It Works

The to-do list lives in a Notion database. The first time someone uses this skill, you'll need to create that database. After that, you just add items to it, search it, or update items in it.

## Setup: Creating the Database (First-Time Only)

If the user has never used this skill before, you need to create the Notion database. Search Notion first to check whether a database called "To-Do List" already exists:

```
Use notion-search with query "To-Do List" to look for an existing database.
```

If no database is found, create one:

```
Use notion-create-database with:
  title: "To-Do List"
  schema: CREATE TABLE (
    "Task" TITLE,
    "Due Date" DATE,
    "Tags" MULTI_SELECT('Work':blue, 'Personal':green, 'Errands':orange, 'Health':red, 'Finance':purple, 'Learning':yellow),
    "Stage" SELECT('Backlog':default, 'Spec':blue, 'Architecture':purple, 'Implementation':orange, 'Testing':yellow, 'Documentation':green, 'Done':green),
    "Repo" RICH_TEXT,
    "Branch" RICH_TEXT,
    "PR URL" URL,
    "Spec" RICH_TEXT,
    "Architecture Plan" RICH_TEXT,
    "Notes" RICH_TEXT,
    "Done" CHECKBOX,
    "Created" CREATED_TIME
  )
```

After creating the database, save the **data_source_id** from the response — you'll need it for every subsequent operation. Tell the user the database has been created and they can find it in their Notion workspace.

If a database IS found, use `notion-fetch` on it to get the data_source_id and confirm the schema.

## Adding a To-Do Item

When the user wants to add a task, extract the following from their message:

- **Task** (required): The title/name of the to-do item
- **Due Date** (optional): Any mentioned date, converted to YYYY-MM-DD format. Interpret relative dates like "tomorrow", "next Friday", "in 3 days" based on today's date.
- **Tags** (optional): Infer from context. For example, "buy groceries" is likely "Errands", "finish the report" is likely "Work", "go to the gym" is likely "Health". If unclear, don't set a tag — it's better to skip than guess wrong.
- **Notes** (optional): Any extra detail the user provides beyond the core task name.
- **Repo** (optional): If the task is related to a GitHub repo, include it as "owner/repo".
- **Stage** (optional): Defaults to "Backlog" for feature work. For non-dev tasks, leave blank.

Use `notion-create-pages` to add the item:

```
Use notion-create-pages with:
  parent: { data_source_id: "<the-data-source-id>" }
  pages: [{
    properties: {
      "Task": "<task title>",
      "date:Due Date:start": "<YYYY-MM-DD or omit>",
      "date:Due Date:is_datetime": 0,
      "Tags": "<tag or omit>",
      "Stage": "<stage or omit>",
      "Repo": "<owner/repo or omit>",
      "Notes": "<notes or omit>",
      "Done": "__NO__"
    }
  }]
```

After adding, confirm to the user with a brief summary: what was added, the due date if set, and the tag if set.

### Batch Adding

If the user gives you multiple items at once (e.g., "add buy milk, call dentist, and finish report"), add them all in a single `notion-create-pages` call by including multiple page objects in the pages array. This is faster and feels more responsive.

## Viewing To-Do Items

When the user asks to see their tasks, use `notion-search` with the data_source_url set to the collection URL of the database:

```
Use notion-search with:
  query: "<relevant search term or broad term like 'task'>"
  data_source_url: "collection://<data-source-id>"
```

Present the results in a clean, readable format. Group by tags or due date if the user has a lot of items. Highlight overdue items if any due dates are in the past. For feature tasks, show the current Stage.

## Marking Items as Done

When the user says something like "I finished X" or "mark X as done", search for the item first, then update it:

```
Use notion-update-page with:
  page_id: "<the page id of the to-do item>"
  command: "update_properties"
  properties: { "Done": "__YES__", "Stage": "Done" }
```

## Updating Items

If the user wants to change a due date, add notes, modify a task, or advance a stage, search for it first, then use `notion-update-page` with the updated properties.

## Tips for a Great Experience

- **Be concise in confirmations.** After adding a task, a simple "Added 'Buy groceries' to your list (tagged as Errands, due tomorrow)" is perfect. Don't over-explain.
- **Handle ambiguity gracefully.** If the user says "add milk" — that's a valid task title. Don't ask "what do you mean by milk?" Just add "Buy milk" or "Milk" to the list.
- **Interpret dates naturally.** "Next week" means the coming Monday. "End of month" means the last day of the current month. "Friday" means the upcoming Friday (or today if it IS Friday).
- **Multiple items in one message are common.** Users often rattle off several things at once. Catch them all and batch-add them.
- **When listing tasks, keep it scannable.** Use a brief format, not a wall of text.
- **Non-dev tasks don't need pipeline columns.** Only set Stage/Repo/Branch for development work.
