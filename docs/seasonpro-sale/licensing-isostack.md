# SeasonPro Strategic Partnership — IsoStack Licensing And Technical Separation Assessment

Date: 2026-08-24

Status: Strategic and technical assessment for specialist UK legal review; not legal advice

## Executive Conclusion

Your instinct is commercially and legally sound. The most suitable structure is a
**licensed product carve-out**, not an assignment of IsoStack and not a direct licence to
the strategic partner.

```text
Isoblue Limited
├── owns IsoStack background IP and reusable platform services
├── retains FUND, Commerce, other modules and future platform development
└── licenses a defined IsoStack + LMSPro distribution to SeasonPro Ltd

SeasonPro Ltd
├── owns specifically assigned SeasonPro IP, brand and customer relationships
├── operates its own repository and infrastructure
└── strategic partner acquires 50% of SeasonPro Ltd shares only
```

This is a viable structure, subject to a specialist UK IP/corporate solicitor confirming ownership and drafting it.

## Can IsoStack be licensed?

Yes. UK copyright protects software automatically, and a copyright owner can license use without transferring ownership. An assignment, by contrast, transfers ownership. [UK IPO copyright guidance](https://www.gov.uk/copyright), [UK IPO licensing guidance](https://www.gov.uk/guidance/licensing-intellectual-property).

The licensable package could include:

- IsoStack source and object code needed by SeasonPro;
- shared authentication, tenancy, RBAC, communications, audit and storage services;
- the necessary database models and migrations;
- supporting documentation and deployment material;
- confidential know-how;
- database rights where applicable; and
- limited trademark rights, if SeasonPro needs to refer to IsoStack.

Third-party libraries remain governed by their own licences. Isoblue can only license rights it actually owns.

The current repository is marked `"private": true`, but that is an npm publication setting—not an IP licence or proof of ownership. I found no top-level proprietary `LICENSE` or `NOTICE`, so the licensable material and third-party dependencies need to be formally inventoried.

## Important warning about “exclusive and perpetual”

A licence does not automatically prevent economic disposal of the technology.

Under section 92 of the Copyright, Designs and Patents Act, a true exclusive copyright licence can exclude even the copyright owner from exercising the licensed right. [CDPA 1988, section 92](https://www.legislation.gov.uk/ukpga/1988/48/section/92).

Therefore, an unconditional perpetual exclusive licence covering “club software” could substantially sterilise Isoblue’s future use of IsoStack even though legal title remains with Isoblue.

I recommend separating:

1. **Technical foundation rights:** a durable, non-transferable source-code licence allowing SeasonPro Ltd to build, modify, host and operate the defined SeasonPro distribution.

2. **Commercial exclusivity:** a conditional covenant giving SeasonPro Ltd exclusivity in a precisely defined market, while expressly preserving Isoblue’s right to develop, maintain and license the generic platform elsewhere.

“Club software space” is far too broad for contractual use. The field should define:

- sport or sports;
- grassroots, amateur, semi-professional or professional level;
- league administration versus individual-club administration;
- customer type;
- territory;
- sales channels;
- included functions; and
- excluded products and capabilities.

Fundraising, generic commerce, payments, generic communications, support ticketing, CRM, other sports and unrelated IsoStack modules should be expressly reserved unless deliberately included.

Exclusivity should normally be conditional on continued operation, investment or agreed performance. The UK IPO’s own checklist asks parties to settle improvement ownership, licence-backs, sales targets and whether failure should cause loss of exclusivity or termination. [UK IPO licensing checklist](https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/385819/licensingchecklist.pdf).

## Technical separation options

| Model | Independence | Protection of wider IsoStack IP | Assessment |
|---|---:|---:|---|
| Second deployment from the current monorepo | Operational only | Strong if partner receives no source access | Useful temporarily, but SeasonPro cannot develop independently |
| Complete GitHub fork of the monorepo | High | Poor | Exposes FUND, Commerce, other modules and repository history; not recommended |
| Curated `IsoStack runtime + LMSPro` distribution | High | Good | Recommended near-term solution |
| Versioned private IsoStack packages plus a SeasonPro repository | High | Very good | Best long-term architecture |
| Isoblue-hosted platform API used by SeasonPro | Limited | Strongest | Creates continuing dependency and requires substantial redesign |
| Assignment of the relevant platform | High | Poor | Unnecessary and commercially dangerous |

### Recommended near-term model

Create a new private SeasonPro repository containing only:

```text
defined licensed IsoStack runtime
+ shared services genuinely required by SeasonPro
+ LMSPro domain code and routes
+ SeasonPro database schema, migrations and jobs
```

This should be a **sanitised source export with a new root commit**, not a normal GitHub fork retaining the entire history. Deleted files and old commits can otherwise disclose unrelated IsoStack source.

The initial distribution should have an immutable manifest recording:

- source repository and exact baseline commit;
- included files and components;
- expressly excluded modules;
- permitted documentation;
- database and migration baseline;
- third-party dependency/SBOM inventory;
- copyright ownership classification; and
- the licence applying to each component.

SeasonPro could then have its own:

```text
local branch → dev → staging → main/live
```

Isoblue would supply approved security or core updates as versioned releases or controlled patches. SeasonPro would decide when to adopt them.

### Best long-term model

Gradually turn the shared foundation into private, versioned Isoblue components:

```text
seasonpro-app
├── SeasonPro-owned LMSPro source
└── licensed @isoblue/isostack-* runtime
    ├── authentication and tenancy
    ├── RBAC
    ├── communications
    ├── storage
    ├── audit
    └── shared UI/runtime contracts
```

This allows SeasonPro to develop independently while Isoblue continues evolving IsoStack without exposing FUND or other modules.

## Present technical reality

The architectural concept supports this separation: the documentation treats IsoStack as a platform and LMSPro as a vertical module, with module-specific domain behaviour sitting above Core. See the [module architecture scope](../core/modules/module-architecture-template.md#2-scope-and-non-goals).

However, LMSPro is not currently a standalone plugin:

- it shares one private monorepo and build;
- application routes sit outside `src/modules/lmspro`;
- Core and LMSPro currently import each other;
- Prisma uses one schema and ordered migration history across multiple products;
- users, organisations, roles, communications and audit models are shared;
- shared jobs execute LMSPro, Commerce and other work in the same runtime.

The LMSPro router (`isostack-bedrock/src/modules/lmspro/routers/index.ts`) still imports LMSPro-specific routers from Core, while the Core router (`isostack-bedrock/src/server/core/routers/index.ts`) statically mounts LMSPro. The Prisma schema (`isostack-bedrock/prisma/schema.prisma`) spans the shared platform and multiple modules.

Consequently:

> A separate deployment is easy; a clean, independently developable source distribution requires a bounded separation project.

## Ownership schedule

Avoid joint ownership wherever possible. A workable allocation would be:

| Asset | Proposed owner |
|---|---|
| IsoStack existing platform, shared services and generic architecture | Isoblue Limited |
| FUND, Commerce and other modules | Isoblue Limited |
| Generic future IsoStack improvements | Isoblue Limited |
| Defined LMSPro/SeasonPro domain code, workflows and content | SeasonPro Ltd |
| SeasonPro brand, domain and product goodwill | SeasonPro Ltd |
| Customer data | The relevant customers/controllers, not either software company |
| Third-party software | Its respective licensors |

For future development:

- SeasonPro-only changes belong to SeasonPro Ltd.
- Generic Core improvements belong to Isoblue or are assigned/licensed back to it.
- SeasonPro retains the necessary licence to every Core improvement included in its distribution.
- Ambiguous changes are classified before development or merge.
- No automatic entitlement arises to future IsoStack modules or versions.

Chain of title must be checked before making these representations. UK IPO guidance confirms that contractors and commissioned creators ordinarily retain copyright unless written terms provide otherwise. [UK IPO ownership guidance](https://www.gov.uk/guidance/ownership-of-copyright-works). The historic documentation also refers to a predecessor league system developed jointly with another individual; confirm that no predecessor code or assets entered LMSPro without an appropriate licence or assignment.

## Agreement package

Before equity is issued or repository access granted, I would expect:

1. **IP ownership and assignment agreement**
   Precisely transfers the agreed existing SeasonPro-specific assets to SeasonPro Ltd.

2. **IsoStack Foundation Licence**
   Defines the baseline distribution, field, territory, source rights, permitted modifications, hosting, contractors, sublicensing, exclusions and reserved Isoblue rights.

3. **Development and maintenance agreement**
   Governs security updates, upstream changes, compatibility, support, costs and improvement ownership.

4. **Shareholders’ agreement**
   Makes amendment, assignment, sublicensing, charging or surrender of the IsoStack licence a reserved matter requiring Isoblue consent. It also needs 50/50 deadlock, exit and change-of-control provisions.

5. **Updated customer legal pack**
   Current draft documents say that both IsoStack and SeasonPro remain exclusively owned and operated by Isoblue. For example, the [current SaaS framework](../modules/lmspro/legal-documents/SaaS-legal-framework.md#20-intellectual-property) conflicts directly with the proposed structure.

6. **Data protection allocation**
   SeasonPro Ltd’s independent operation changes the controller/processor and subprocessor relationships. Written contracts and responsibilities are required where one organisation processes personal data for another. [ICO controller/processor guidance](https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/accountability-and-governance/contracts-and-liabilities-between-controllers-and-processors-multi/).

The strategic partner should acquire shares in SeasonPro Ltd but receive **no direct IsoStack licence**. SeasonPro’s licence should not be assignable, sublicensable, charged as security or expanded without Isoblue’s consent.

## Infrastructure separation

SeasonPro should own or control separate:

- Git repository and access permissions;
- Render services and environment groups;
- Neon project, databases and backups;
- R2 buckets and scoped credentials;
- Resend account, sending domain and keys;
- Redis/rate-limiting service;
- authentication secrets and WebAuthn configuration;
- encryption keys;
- Stripe account and webhooks where applicable;
- DNS, monitoring, logs and disaster recovery.

There should be no shared production database branches, buckets, credentials or customer datasets.

Before sharing any repository material, note that the tracked `.env.example` presently contains a credential-like database connection value. It should be investigated, removed from distributable history and rotated if genuine; I have not reproduced it here.

## Recommended immediate sequence

1. Do not grant the partner repository access yet; use an NDA and non-binding term sheet.
2. Complete a chain-of-title and third-party dependency audit.
3. Define the Background IP, SeasonPro IP, excluded IP and improvement rules.
4. Agree the narrow commercial field and conditional exclusivity.
5. Have an IP solicitor draft the licence and assignment alongside the shareholders’ agreement.
6. Create the sanitised SeasonPro distribution and completely separate infrastructure.
7. Prove independent build, migration, deployment, security and recovery.
8. Replace the current Isoblue-only customer terms before SeasonPro Ltd contracts with clients.

The central recommendation is:

> **Isoblue retains IsoStack; SeasonPro Ltd owns the product-specific layer and receives a carefully scheduled, non-transferable foundation licence plus conditional field exclusivity; the partner owns shares only in SeasonPro Ltd.**

That protects the wider technology while giving the partnership a credible, independently operable product asset.
