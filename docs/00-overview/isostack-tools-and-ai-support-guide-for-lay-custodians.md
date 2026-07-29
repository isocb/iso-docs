# IsoStack Tools And AI Support Guide For Lay Custodians

Purpose: explain the principal tools used to operate and support IsoStack in language suitable
for a complete novice.

Objectives:

- **A — Awareness:** know which tools are in use and what each one does.
- **B — Support:** know where to start when something is unclear or not working.
- **C — AI assistance:** know how to ask ChatGPT or Codex for safe, useful help.

Audience: an authorised Isoblue partner temporarily helping to preserve IsoStack while the
usual developer is unavailable.

Status: orientation and support guide. It does not authorise development, deployment, database
work or access to customer data.

Owner: Isoblue / IsoStack

Last verified: 2026-07-29

Internal use only. Never add passwords, secret keys, recovery codes, database connection
strings or customer data to this guide or an AI prompt.

## 1. Read These Three Documents Together

This guide explains the tools. It supports, but does not replace:

1. [Routine IsoStack Management Handbook](./routine-isostack-management-handbook.md) — what a
   lay custodian may check or do while development support is unavailable.
2. [Technical Continuity And Succession Handbook](./technical-continuity-and-succession-handbook.md)
   — technical structure, succession, controlled handover and resumption of development.
3. This guide — what the named tools are, where to seek support and how to use AI safely.

For current documentation navigation, use the
[IsoDocs Documentation Map](../../DOCUMENTATION_MAP.md).

The recurring review schedule and evidence structure are governed by the
[Continuity And Operational Assurance Cycle](./continuity-and-operational-assurance-cycle.md).

If an AI answer conflicts with either handbook, follow the handbook and seek qualified human
help.

## 2. The Whole Ecosystem In One Picture

```text
                         PEOPLE AND WORK

              ChatGPT
        explains, drafts and helps
        think in plain language
                    |
                    | text/files supplied by a person
                    v
        Visual Studio Code (VS Code)
        opens the local project files
                    |
                    +------ Codex IDE extension
                    |       reads the local context and,
                    |       when authorised, can act on it
                    |
                    v
                  Git
        tracks local file versions
                    |
                    v
                 GitHub
        stores shared code, history and checks
                    |
                    | approved branch/deployment flow
                    v

                         RUNNING SERVICE

                 Render
        runs the website and scheduled jobs
                    |
          +---------+----------+
          |                    |
          v                    v
        Neon                 Resend
   stores durable         sends application
   application data      and sign-in email
          |
          +--------------------+
                               |
                               v
                         Upstash Redis
                  holds short-lived security,
                  rate-limit and session state
```

The arrows show relationships, not permission. For example, opening GitHub does not give a
person permission to deploy, and asking Codex a question does not authorise it to change a
file.

## 3. Three Easily Confused Names

### 3.1 Visual Studio Code Is Not Visual Studio

IsoStack is normally opened in **Visual Studio Code**, usually shortened to **VS Code**.

VS Code is a lightweight Microsoft editor used to view folders, code, documents, changes and
an integrated terminal. **Visual Studio** is a different Microsoft development product.

Unless an IsoStack instruction explicitly says otherwise, "open the project in VS" means open
it in **Visual Studio Code**.

### 3.2 Git Is Not GitHub

**Git** is the version-tracking system on the computer. It records changes as commits and
supports branches.

**GitHub** is the online service that stores shared copies of Git repositories and provides
access management, pull requests, history and automated checks.

A file can be:

- changed on one computer but not committed;
- committed locally but not pushed to GitHub; or
- pushed to GitHub but not deployed by Render.

Those are three different states.

### 3.3 ChatGPT Is Not Codex

**ChatGPT** is the general AI assistant used for explanation, research, drafting, planning and
working with supplied files.

**Codex** is OpenAI's software-development agent. In VS Code, the Codex IDE extension can work
beside the open repository and understand local files, selected text and Git changes. Subject
to its permissions, it can also edit files and run commands.

For a lay custodian:

- use ChatGPT for plain-language explanations, communications and preparing questions;
- use Codex for read-only inspection of the actual local IsoStack files;
- do not allow either one to deploy, migrate, restore or change the live service during the
  holding period.

## 4. Tool-By-Tool Guide

### 4.1 GitHub — The Shared Record

#### What It Is

GitHub is the online home of IsoStack's source repositories and their history.

The principal repositories are:

- `isocb/isostack-bedrock` — application code, database migrations, tests and operational
  scripts; and
- `isocb/iso-docs` — canonical internal documentation, including these handbooks.

#### What GitHub Does For IsoStack

- stores code and documentation away from one person's computer;
- records who changed what and when;
- keeps separate branches for work, development, staging and live;
- runs automated GitHub Actions checks;
- provides access for authorised collaborators; and
- supplies approved code to Render's deployment process.

GitHub does not store the live customer database. It should not contain live passwords or
secret keys.

#### What A Lay Custodian May Safely Do

- view repositories, commit history and branch names;
- view whether GitHub Actions passed or failed;
- record the current `main` commit identifier;
- maintain organisation billing;
- confirm there are at least two authorised organisation owners; and
- invite an approved replacement using their own account and MFA.

#### What Requires Technical Support

- editing or committing files;
- merging a pull request;
- pushing, deleting or renaming a branch;
- changing branch protection;
- creating a release;
- changing Actions or security settings;
- installing an App, webhook or deploy key; or
- making a repository public, transferring it or deleting it.

#### Start Here For Help

- Open the GitHub organisation, then the relevant repository.
- For code history or checks, open the repository's **Actions** or **Commits** page.
- For account access, use organisation **People** and **Settings** only with proper authority.
- Use [GitHub organisation documentation](https://docs.github.com/en/organizations) or GitHub
  Support for unfamiliar account controls.

### 4.2 Visual Studio Code — The Local Viewing And Working Area

#### What It Is

VS Code opens the repository folders stored on a computer. It displays documents, code,
search results, local Git changes and the Codex sidebar.

Think of it as the desk on which the files are examined. GitHub is the shared filing cabinet;
VS Code is not itself the shared record.

#### What VS Code Does For IsoStack

- opens the local `isostack-bedrock` and `isodocs` folders;
- lets a person search and read files;
- displays differences between changed and committed versions;
- provides the Source Control view for local Git state;
- hosts the Codex IDE extension; and
- provides a terminal for qualified technical work.

#### What A Lay Custodian May Safely Do

- open the known IsoStack workspace or repository folder;
- read Markdown documentation;
- search for a filename or phrase;
- view the Source Control list without clicking commit/sync controls;
- open the Codex sidebar and ask a read-only question; and
- close VS Code without saving an accidental edit.

#### What Requires Technical Support

- accepting automatic fixes;
- editing source code or configuration;
- using the terminal;
- resolving a merge conflict;
- clicking Commit, Sync, Pull, Push, Publish or Switch Branch;
- installing an unknown extension; or
- opening or copying `.env`, credential or secret files.

#### Start Here For Help

- Confirm the application title says **Visual Studio Code**, not Visual Studio.
- Use **File → Open Recent** to select the known workspace.
- Use [VS Code source-control documentation](https://code.visualstudio.com/docs/sourcecontrol/overview)
  for terminology, but do not follow commit or sync instructions during the holding period.
- For a display/editor problem, use VS Code **Help** and the official VS Code documentation.

### 4.3 Codex — The AI Agent Beside The Files

#### What It Is

Codex is OpenAI's coding agent. The Codex IDE extension places it inside VS Code, next to the
open project.

Codex can be more useful than a general chat for repository questions because it can inspect
the actual files available in the workspace. This also means it must be given clear limits:
depending on permissions and the request, an agent may be able to edit files, run commands or
use connected tools.

#### What Codex Does For IsoStack

- reads documentation and source files;
- searches the repository;
- explains relationships between files and services;
- checks current Git state;
- drafts or reviews documentation;
- helps qualified developers plan, implement and verify changes; and
- keeps a record of the request and its reported result in the chat.

Codex is an assistant, not the product owner, legal authority, database owner or production
release approver.

#### Safe Lay Use

Ask Codex to:

- read the three continuity documents;
- explain a term or file in plain English;
- identify which handbook section applies;
- inspect without changing anything;
- summarise a non-secret error;
- prepare questions for provider support;
- draft an incident record or customer update; and
- list what information a replacement developer will need.

#### Unsafe Lay Use

Do not ask or allow Codex to:

- "fix it now";
- edit code or configuration;
- commit, push, merge, deploy or roll back;
- run database, migration, seed, reset or restore commands;
- change a module, permission, user role or product allocation;
- rotate a key or edit an environment variable;
- access live customer data; or
- work around a provider/security control.

#### Useful Codex Controls

In the Codex composer, typing `/` shows available commands. Useful read-only controls include:

- `/status` — shows chat and usage status;
- `/model` — shows or selects an available model;
- `/reasoning` — shows or selects reasoning effort; and
- `/feedback` — opens the product feedback flow.

Do not use a slash command you do not understand.

#### Start Here For Help

- Open the Codex sidebar in VS Code.
- Start a new chat for a new incident or subject.
- Paste the "Safe AI Boundary" from Section 8 before the question.
- Use [Codex IDE documentation](https://learn.chatgpt.com/docs/codex/ide) and
  [Codex model guidance](https://learn.chatgpt.com/docs/models).
- If Codex itself fails, use `/status`, then `/feedback`, or contact OpenAI support. Do not
  try to repair the extension by changing the repository.

### 4.4 ChatGPT — The Plain-Language Thinking Partner

#### What It Is

ChatGPT is a general AI assistant available through web, desktop and other supported
experiences. It is well suited to explaining concepts, turning notes into a support request,
drafting communications and checking whether a proposed action sounds risky.

ChatGPT normally knows only what is supplied in the conversation or made available through an
explicitly connected tool. It should not be assumed to see the local VS Code workspace,
private GitHub repository or provider dashboards.

#### What ChatGPT Can Do For A Lay Custodian

- explain a screenshot or non-secret message;
- turn an incident timeline into a clear summary;
- compare the handbooks with a proposed action;
- draft customer or provider communications;
- create a checklist;
- prepare questions for a technical interview; and
- explain the answer received from a provider.

#### What ChatGPT Cannot Decide

ChatGPT cannot grant business authority, confirm that a destructive action is safe, verify a
live database by guesswork or replace a qualified developer/database specialist.

#### Start Here For Help

- Start a new chat and state that you are a lay IsoStack continuity custodian.
- Attach only the relevant handbook or a carefully redacted screenshot.
- Ask for plain English and request that assumptions be labelled.
- Ask it to recommend the correct human/provider support route.
- Use [official ChatGPT guidance](https://learn.chatgpt.com/docs/use-chatgpt) for general use.

### 4.5 Sol–High In VS Code — A Model And Reasoning Choice

#### What The Name Means

As of this guide's verification date:

- **Sol** refers to OpenAI's `gpt-5.6-sol` model; and
- **High** refers to the selected reasoning effort.

Together, "Sol–High" means Codex is using the Sol model and has been allowed more reasoning
effort for that task. It is not a separate application, employee, support contract or
repository.

The visible product name or options may change. Use the Codex model selector or `/model` and
`/reasoning` to see the current selection rather than relying on an old screenshot.

#### When Sol–High Is Useful

Use it for difficult, multi-step, high-value questions such as:

- reconciling several documentation sources;
- interpreting an incident timeline and multiple logs;
- preparing a careful technical handover;
- reviewing whether a proposed action crosses a safety boundary; or
- explaining a complex architectural dependency.

Higher reasoning can take longer and use more of the available allowance. It does not make
unsafe instructions safe or remove the need for human review.

For a simple definition or short email, the normal/default setting is usually sufficient.

### 4.6 Render — Where IsoStack Runs

#### What It Is

Render is the hosting platform that runs the live IsoStack web application and scheduled
background jobs.

The current repository expects a web service with `/api/health` and a scheduled job used for
queued work such as parts of email delivery.

#### What A Lay Custodian Uses It For

- see whether the live web service is running;
- view the current deployed commit and time;
- view recent logs and basic metrics;
- view scheduled-job results;
- maintain billing and authorised team access; and
- contact Render support.

#### Important Boundary

Do not click Deploy, Rollback, Shell, One-off Job or edit an environment value. IsoStack's
normal build can run database migrations, so a manual deploy is not a harmless refresh.

The one limited restart procedure is defined only in the
[Routine Management Handbook](./routine-isostack-management-handbook.md#94-the-one-permitted-restart).

#### Start Here For Help

- Check [Render status](https://status.render.com/).
- Open the correct live web service and record its state.
- Follow the routine handbook; do not improvise.
- Use [Render dashboard documentation](https://render.com/docs/render-dashboard) and Render
  Support.

### 4.7 Neon — Where Durable Application Data Lives

#### What It Is

Neon provides the PostgreSQL database used by IsoStack. It stores durable records such as
organisations, users, permissions, modules, projects and audit information.

Neon "branches" are separate database states. They are not the same as GitHub code branches,
even though both use the word branch.

#### What A Lay Custodian Uses It For

- confirm that the expected project is available;
- view service, usage, storage and billing warnings;
- view team membership;
- view the configured restore window; and
- contact Neon support.

#### Important Boundary

Do not run SQL, copy connection strings, restore data, change branches, edit roles or try to
repair a record. A restore can remove correct recent information as well as bad information.

If data looks wrong, record the earliest known time and escalate without changing Neon.

#### Start Here For Help

- Check the correct region at [Neon status](https://neonstatus.com/).
- Record the project name and time of the problem, but not its connection string.
- Use [Neon project documentation](https://neon.com/docs/manage/projects) and Neon Support.

### 4.8 Resend — Application And Sign-In Email Delivery

#### What It Is

Resend is the external email-delivery provider used by IsoStack. The application sends email
to Resend, and Resend attempts delivery to the recipient's mail system.

IsoStack uses Resend for functions including sign-in links, invitations, verification,
notifications, security alerts and module communications.

#### What A Lay Custodian Uses It For

- check provider status;
- view delivery events for a specific, authorised investigation;
- see whether a sending domain is verified;
- view broad delivery, bounce or suppression problems;
- maintain billing and authorised team access; and
- contact Resend support.

#### Important Boundary

Do not create/revoke API keys, change DNS/domain settings, resend messages in bulk, alter
suppressions or expose recipient/message contents without authority.

An email problem can originate in IsoStack, its Render scheduled job, Resend, the sending
domain or the recipient's mail provider. A Resend dashboard result is one piece of evidence,
not always the whole answer.

#### Start Here For Help

- Check [Resend status](https://resend-status.com/).
- Record the approximate send time, recipient domain and message type. Avoid copying message
  content.
- Check the scheduled-job result in Render when the message was queued.
- Use [Resend documentation](https://resend.com/docs) and Resend Support.

### 4.9 Upstash Redis — Short-Lived Security And Traffic Memory

#### What It Is

Upstash provides Redis, a fast store used for short-lived operational state. It is not the
main customer database.

IsoStack currently uses Upstash Redis for:

- rate limiting — slowing or blocking too many repeated requests;
- failed-login and temporary lockout counters;
- anti-spam cooldowns; and
- rapid session revocation after events such as a role change or account suspension.

#### What A Lay Custodian Uses It For

- check provider/database availability;
- view usage and billing warnings;
- confirm the expected database still exists;
- maintain authorised team access; and
- contact Upstash support.

#### Important Boundary

Do not open the CLI, run Redis commands, delete keys, flush the database, create/revoke tokens
or change the Render Upstash values.

If Upstash is unavailable, some security/rate-limit functions may degrade even if Neon and
the main website remain available. Record the symptom; do not assume Upstash is the cause
without technical evidence.

#### Start Here For Help

- Check [Upstash status](https://upstash.instatus.com/).
- Record the database/provider status and time without copying its endpoint or token.
- Use [Upstash Redis documentation](https://upstash.com/docs/redis) and Upstash Support.

## 5. Where To Start When Something Goes Wrong

| What you observe                                  | First place to look                                   | Then                                                                                |
| ------------------------------------------------- | ----------------------------------------------------- | ----------------------------------------------------------------------------------- |
| Whole website unavailable                         | Routine handbook incident checklist and `/api/health` | Render status/dashboard, then Neon status                                           |
| Health says database disconnected                 | Neon status and Render logs                           | Neon/Render support and emergency technical contact                                 |
| Health shows RLS below `11/11`                    | Treat as a Red security incident                      | Security/privacy and emergency technical contact                                    |
| One user cannot sign in                           | Confirm correct address/account; record exact time    | Resend delivery evidence and Render logs; Upstash may require technical review      |
| Everyone cannot sign in                           | `/api/health`, Render and Resend status               | Treat as Red and escalate                                                           |
| Email is delayed                                  | Render scheduled-job result                           | Resend status/delivery evidence                                                     |
| Too many requests, temporary block or lockout     | Record user/time/action without retrying repeatedly   | Upstash and Render evidence; technical support                                      |
| Data appears missing or crossed between customers | Stop affected activity                                | Security/privacy contact and Neon-qualified technical support; do not query/restore |
| GitHub Action fails                               | GitHub Actions job summary                            | Record and send to replacement developer; live site may still be healthy            |
| VS Code cannot open the project                   | Confirm correct application/folder                    | VS Code documentation or desktop support; do not initialise a new repository        |
| Codex gives an error                              | `/status`, new chat if appropriate                    | `/feedback` or OpenAI support                                                       |
| Unsure which system is responsible                | Start an incident record                              | Ask ChatGPT/Codex to classify without changing anything                             |

## 6. Information To Gather Before Asking For Help

Good support starts with facts, not guesses.

Gather:

- date and time, including UTC if possible;
- your name and authority/role;
- affected organisation and module;
- exact page address without private tokens;
- what the user tried to do;
- exact visible error, carefully redacted;
- whether the problem affects one user or several;
- website and `/api/health` result;
- Render service status and current deploy identifier/time;
- scheduled-job result if email/background work is involved;
- relevant provider status page result;
- whether any deploy, configuration or access change recently occurred; and
- what has deliberately not been changed.

Do not gather or share more customer data than the support case requires.

## 7. Before Sharing Anything With AI

Remove or cover:

- passwords and recovery codes;
- API keys, tokens and webhook secrets;
- database URLs or connection strings;
- `.env` file contents;
- signed file links;
- session cookies and browser developer authentication headers;
- customer names, email addresses, addresses, telephone numbers and payment details unless
  strictly authorised and necessary;
- private message/attachment contents; and
- security answers or MFA codes.

If unsure, describe the field rather than its value:

```text
DATABASE_URL is present in the live Render service.
```

Do not write:

```text
DATABASE_URL=<the actual value>
```

## 8. Safe AI Boundary

Add this block to the beginning of any Codex or ChatGPT support prompt:

```text
I am a lay IsoStack continuity custodian, not a developer.

This is a read-only support request. Do not edit files, run write commands, commit, push,
merge, deploy, roll back, use a shell, run SQL, migrate or restore a database, change an
environment variable, rotate a key, change user/module permissions, or access customer data.

Use the Routine IsoStack Management Handbook, the Technical Continuity And Succession
Handbook and the IsoStack Tools And AI Support Guide as the authority. Explain your answer in
plain English, cite the relevant file/section or official provider source, label assumptions,
and stop if the next action requires technical or business authority.
```

This boundary reduces risk; it is not a guarantee. Read the proposed answer before acting.

## 9. Suggested Prompts

### 9.1 First Orientation In Codex

```text
[Paste the Safe AI Boundary.]

Read these files:
- isodocs/DOCUMENTATION_MAP.md
- isodocs/docs/00-overview/routine-isostack-management-handbook.md
- isodocs/docs/00-overview/technical-continuity-and-succession-handbook.md
- isodocs/docs/00-overview/isostack-tools-and-ai-support-guide-for-lay-custodians.md

Do not change anything. Give me a one-page novice orientation covering:
1. what I am responsible for;
2. what I must never do;
3. the weekly checks;
4. who or which provider to contact for each main type of problem; and
5. the information I should record during an incident.
```

### 9.2 Check Which Handbook Rule Applies

```text
[Paste the Safe AI Boundary.]

I am considering this action:
[describe the action without secrets]

Compare it with the three IsoStack continuity guides. Tell me:
- whether it is allowed for a lay custodian;
- the exact section that applies;
- the safest next step;
- which human or provider should own it; and
- what evidence I should record.

Do not perform the action.
```

### 9.3 Explain A Provider Screen Or Error

```text
[Paste the Safe AI Boundary.]

This is a redacted message/screenshot from [Render / Neon / GitHub / Resend / Upstash]:
[attach or paste the redacted content]

Explain:
1. what it says in plain English;
2. whether it suggests Green, Amber or Red;
3. what facts are missing;
4. what I may safely check without changing anything; and
5. what I should send to provider or technical support.

Do not infer or invent hidden values.
```

### 9.4 Prepare A Provider Support Ticket

```text
[Paste the Safe AI Boundary.]

Turn the following incident notes into a concise support ticket for [provider]:
[paste redacted incident notes]

Include:
- business impact;
- start time and timezone;
- affected service/project name, but no secrets;
- checks already performed;
- exact non-secret errors;
- confirmation that no configuration/database change has been attempted; and
- the specific help or confirmation requested.

Do not claim data loss or a root cause unless the notes prove it.
```

### 9.5 Explain A Failed GitHub Action

```text
[Paste the Safe AI Boundary.]

Read this redacted GitHub Actions job summary:
[paste summary or provide the local non-secret report]

Do not rerun or change the workflow. Explain:
- which check failed;
- whether this affects the currently running live application or only future changes;
- whether it is a security concern;
- what evidence a replacement developer needs; and
- the appropriate urgency.
```

### 9.6 Prepare A Customer Update

```text
[Paste the Safe AI Boundary.]

Using these confirmed facts only:
[paste redacted facts]

Draft a short customer update that:
- states the affected function and known time;
- avoids technical jargon and speculation;
- tells users whether to avoid repeating an action;
- gives the next update time; and
- does not promise a recovery time we cannot prove.
```

### 9.7 Prepare The Replacement Developer Handover

```text
[Paste the Safe AI Boundary.]

Using the three IsoStack continuity guides and these redacted operational notes:
[paste notes]

Prepare a handover checklist for a replacement technical maintainer. Separate:
- confirmed current state;
- access still required;
- open incidents;
- frozen changes;
- customer deadlines;
- provider/account issues;
- unknowns requiring investigation; and
- actions that need explicit business or production approval.

Do not propose implementation or modify the repositories.
```

### 9.8 Ask ChatGPT To Help Choose The Right Support Route

```text
I am a lay custodian keeping an existing IsoStack service stable. I cannot make code,
deployment or database changes.

The symptom is:
[describe it without secrets or customer data]

The website check is:
[result]

The /api/health check is:
[result]

Provider status pages show:
[results]

Classify the issue as likely related to GitHub, VS Code/Codex, Render, Neon, Resend, Upstash,
or still unknown. Explain why, tell me what non-changing evidence to gather next, and draft
the first support question. Do not give me commands or ask me to change the live system.
```

## 10. Warning Signs In An AI Answer

Stop and seek qualified human help if an AI answer:

- asks for a password, token, connection string, `.env` file or customer record;
- tells you to work directly on `main`;
- suggests `db:push`, `db:seed`, reset, SQL, migration or restore;
- suggests clicking Render deploy or rollback;
- suggests changing a Neon branch or connection;
- suggests clearing/flushing Upstash;
- suggests creating/revoking a Resend key or changing DNS;
- says to disable tenant, RLS, permission or security checks;
- claims certainty without citing the actual file, dashboard evidence or official source;
- says a backup exists without verifying the provider/project setting;
- treats a GitHub, Neon or Render "branch" as interchangeable;
- asks you to repeat a customer action that could create duplicates; or
- says "it should be fine" without naming what was verified.

AI is useful for organising evidence and explaining choices. It must not be used to manufacture
authority.

## 11. Provider And Product Support Directory

| Tool               | Official starting point                                                               | Status page                                        |
| ------------------ | ------------------------------------------------------------------------------------- | -------------------------------------------------- |
| GitHub             | [GitHub Docs](https://docs.github.com/) and GitHub Support                            | [GitHub Status](https://www.githubstatus.com/)     |
| Visual Studio Code | [VS Code Docs](https://code.visualstudio.com/docs)                                    | Use Microsoft/VS Code release and support channels |
| Codex              | [Codex IDE Docs](https://learn.chatgpt.com/docs/codex/ide), `/status` and `/feedback` | Check OpenAI service status/support                |
| ChatGPT            | [Use ChatGPT](https://learn.chatgpt.com/docs/use-chatgpt) and OpenAI support          | [OpenAI Status](https://status.openai.com/)        |
| Render             | [Render Docs](https://render.com/docs) and Render Support                             | [Render Status](https://status.render.com/)        |
| Neon               | [Neon Docs](https://neon.com/docs) and Neon Support                                   | [Neon Status](https://neonstatus.com/)             |
| Resend             | [Resend Docs](https://resend.com/docs) and Resend Support                             | [Resend Status](https://resend-status.com/)        |
| Upstash Redis      | [Upstash Redis Docs](https://upstash.com/docs/redis) and Upstash Support              | [Upstash Status](https://upstash.instatus.com/)    |

Official documentation explains the controls a product offers. It does not authorise a lay
custodian to use destructive or production-changing controls.

## 12. A Successful First Week

By the end of the first week, the lay custodian should be able to:

- describe the role of each tool in one sentence;
- distinguish VS Code from Visual Studio, Git from GitHub, and ChatGPT from Codex;
- explain that Sol–High is a model/reasoning selection;
- find all three continuity guides;
- perform the non-changing weekly checks in the routine handbook;
- recognise which dashboard should be consulted for a given symptom;
- prepare a redacted incident record and provider support request;
- use the Safe AI Boundary before asking for help;
- recognise an unsafe AI suggestion; and
- preserve the live service without attempting development.
