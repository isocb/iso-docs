# FUND Ecwid Commerce Platform Appraisal

Date: 2026-07-08
Module: FUND
Document type: Controlled appraisal / architecture input
Status: Draft shell
Related planning:

- `docs/modules/fund/03-slice-planning/2026-07-08-fund-phase-1-slice-1r-a-store-orders-commerce-core-planning.md`
- `docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`
- `docs/modules/fund/00-roadmap-control/2026-06-30-fund-phase-2-refinement-wishlist-and-slice-control.md`

Yes — Ecwid’s **Product Options** feature is a very useful reference model for FUND, especially because FUND will need configurable products, project-specific catalogues, artwork/personalisation choices, hidden suppliers, and potentially different purchase routes.

## 1. The Ecwid idea in plain English

Ecwid treats a **product** as the base item, then lets the merchant attach **options** to that product.

For example:

| Base product        | Product options                           |
| ------------------- | ----------------------------------------- |
| Christmas card pack | Pack size, design, child name, class name |
| Water bottle        | Bottle colour, name to print, font style  |
| Artwork print       | Size, frame option, delivery method       |

Ecwid says product options can be used for colour/size variants, extras such as gift wrapping, multiple selections, personalisation, and price changes. The selected options are then stored against the order, shown in admin, emails and invoices. ([Ecwid Help Center][1])

For FUND, this is exactly the kind of pattern you need: **one controlled catalogue product**, with selectable customer-facing choices layered on top.

---

## 2. Key Ecwid concepts worth copying into FUND

### Product

This is the parent/base product.

In FUND terms:

> “A product offered by a producer/supplier, made available to one or more projects through a catalogue.”

Examples:

* Christmas cards
* Mug
* Water bottle
* Tea towel
* Hoodie
* Art print
* Bulk club/team product

The product should hold the stable information: name, description, base price, product image, production notes, supplier relationship, tax/shipping rules, and whether it is enabled.

---

### Product options

Ecwid supports option types such as:

| Option type       | Meaning                                              |
| ----------------- | ---------------------------------------------------- |
| Drop-down         | Customer chooses one value from a compact list       |
| Radio buttons     | Customer chooses one visible value                   |
| Size              | Size selector, functionally similar to radio buttons |
| Checkboxes        | Customer can choose several extras                   |
| Colour / swatches | Visual colour selection                              |
| Text field        | Customer enters short text                           |
| Text area         | Customer enters longer text                          |
| Date              | Customer selects a date/time                         |
| File upload       | Customer uploads a file                              |

Ecwid’s API describes these as `SELECT`, `RADIO`, `CHECKBOX`, `TEXTFIELD`, `TEXTAREA`, `DATE`, `FILES`, `SIZE`, and `SWATCHES`. ([Ecwid Documentation][2])

For FUND, this maps neatly to:

| FUND need                       | Option type                                           |
| ------------------------------- | ----------------------------------------------------- |
| Choose size                     | Size / radio                                          |
| Choose colour                   | Swatch / radio                                        |
| Add child’s name                | Text field                                            |
| Add class name                  | Text field                                            |
| Upload artwork/photo            | File upload                                           |
| Choose product finish           | Drop-down / radio                                     |
| Add extras                      | Checkbox                                              |
| Choose production/delivery date | Date, probably admin-only rather than customer-facing |

This is especially important for personalised fundraising products, because not everything should become a separate product.

### C1-managed custom order fields

FUND should also support C1-managed custom field definitions for Products or Project
Products. These are ad-hoc fields needed by a specific Product or Project/Product context,
without requiring a developer to add a new database column or hard-code a one-off form.

Examples:

| Product / context           | Custom field needed                     |
| --------------------------- | --------------------------------------- |
| Hoodie                      | Name to print on back                   |
| Team photo product          | Squad name / age group label            |
| Sponsor board               | Sponsor wording                         |
| Bulk club order             | Delivery contact note                   |
| Artwork product             | Artwork reference / additional guidance |

This should still be controlled. C1 should choose from standard data/control types rather
than creating untyped blobs.

Candidate field types:

- short text;
- long text;
- number;
- date;
- yes/no;
- single select;
- multi-select;
- colour/swatch;
- file upload;
- email/phone-style contact input where appropriate.

Each custom field definition should be able to carry:

- label;
- help text;
- required/optional flag;
- default value where relevant;
- allowed choices where relevant;
- production/admin visibility;
- customer-facing visibility;
- validation constraints.

Submitted values must be snapshotted onto the Order line. This protects historic Orders if
the Product, Project Product or custom field definition is later changed.

---

### Option choices

An option can have predefined values.

Example:

```text
Option: Pack size
Choices:
- Pack of 10
- Pack of 20
- Pack of 30
```

or:

```text
Option: Bottle colour
Choices:
- Red
- Blue
- Green
- Black
```

Each choice can optionally affect the price. Ecwid allows price modifiers to be positive or negative, and they can be absolute values or percentages. ([Ecwid Help Center][1])

For FUND, this is useful for things like:

| Choice             | Price modifier |
| ------------------ | -------------: |
| Standard card pack |          £0.00 |
| Larger card pack   |         +£3.00 |
| Framed artwork     |         +£8.00 |
| No gift packaging  |          £0.00 |
| Gift packaging     |         +£1.50 |

Important distinction: in Ecwid, the modifier is **not** the full product price; it is an adjustment to the base product price. ([Ecwid Help Center][1])

That is a good rule for FUND too.

---

## 3. Options versus variations

This is probably the most important distinction.

Ecwid uses **options** for customer choice, but uses **variations** when a particular combination needs its own SKU, image, price, weight, or stock level. For example, “Red / Small” and “White / Medium” can become separate variations. Ecwid specifically recommends variations where you need fixed prices, stock control or separate images. ([Ecwid Help Center][3])

So the rule for FUND should be:

| Use product options when…              | Use product variations when…                      |
| -------------------------------------- | ------------------------------------------------- |
| The choice customises the order        | The choice changes the actual stock/SKU           |
| The choice is captured for production  | The choice needs its own inventory                |
| The choice adds a small price modifier | The choice has a materially different fixed price |
| The choice is personalisation text     | The choice has its own product image/weight       |
| The supplier makes it from order data  | The supplier fulfils it as a distinct variant     |

Example:

```text
Product: Water Bottle

Variation:
- 500ml bottle
- 750ml bottle

Options:
- Colour
- Name to print
- Font style
- Gift packaging
```

For FUND/AMOW-style products, I would avoid creating too many variations too early. Use variations only where they genuinely matter for production, pricing, SKU, stock or fulfilment.

---

## 4. Required options and defaults

Ecwid allows some options to be required, meaning the customer cannot add the item to the cart until they choose a value. It also allows default/preselected values for common choices. ([Ecwid Help Center][1])

This is very relevant for FUND.

Examples of **required** options:

| Product              | Required field           |
| -------------------- | ------------------------ |
| Personalised card    | Child name               |
| Club hoodie          | Size                     |
| Printed water bottle | Name to print            |
| Artwork product      | Artwork selection/upload |
| Class tea towel      | Child/class identifier   |

Examples of **default** options:

| Option         | Default               |
| -------------- | --------------------- |
| Pack size      | Standard pack         |
| Finish         | Standard finish       |
| Delivery       | Project bulk delivery |
| Gift packaging | No                    |

For FUND, I would make required/default behaviour part of the option definition, not hard-coded in the UI.

---

## 5. Order-line snapshot is essential

Ecwid stores the customer’s option choices with the order, and shows them in order details, customer/admin notifications and invoices. ([Ecwid Help Center][1])

This is a critical pattern for FUND.

When an order is placed, FUND should snapshot the selected product configuration onto the **order line**, not just reference the current product/options tables.

Why? Because catalogue options may change later.

Example:

```text
Order line:
Product: Christmas Card Pack
Base price: £12.00
Selected options:
- Pack size: Pack of 20 (+£3.00)
- Child name: Emily Bampton
- Class: Year 3
- Artwork ref: ART-2026-00128
Final line price: £15.00
```

Even if the product changes next season, the historic order must remain clear and auditable.

---

## 6. Advanced option sets

Ecwid also has an Advanced Product Options app that introduces reusable option sets, tooltips/descriptions, visual swatches, number fields, and rules that show/hide options depending on earlier selections. For example, selecting option “A” can reveal sub-options “C” and “D”. ([Ecwid Help Center][4])

For FUND, I would not build all of that immediately, but the concept is valuable.

A later FUND version could support:

```text
Option set: Personalised school product

Options:
- Child name
- Class name
- Artwork upload/ref
- Product finish
- Optional gift packaging
```

Then that option set could be applied to several catalogue products.

This avoids recreating the same options manually across every product.

---

# Recommended FUND design reference

## Core data model

A sensible FUND commerce model inspired by Ecwid would look something like this:

| Entity                         | Purpose                                                                |
| ------------------------------ | ---------------------------------------------------------------------- |
| `Product`                      | Base item supplied by a producer/supplier                              |
| `ProductVariant`               | Optional concrete version with own SKU/price/stock/image               |
| `ProductOption`                | Question/selector shown to buyer/admin                                 |
| `ProductOptionChoice`          | Predefined values for select/radio/checkbox/size/swatch                |
| `ProductOptionSet`             | Reusable group of options                                              |
| `ProjectProduct`               | Product made available to a specific FUND project                      |
| `ProjectProductOptionOverride` | Project-specific labels, required flags, availability, price modifiers |
| `OrderLine`                    | Purchased product/variant                                              |
| `OrderLineOptionSnapshot`      | Frozen record of selected options at time of purchase                  |
| `OrderLineCustomFieldSnapshot` | Frozen record of C1-configured Product/Project Product field values    |

---

## Recommended MVP behaviour

For the first FUND e-commerce slice, I would keep it deliberately controlled:

### Build now

* Base products
* Product options
* Option choices
* Required/default flags
* Price modifiers
* Order-line option snapshots
* C1-managed custom order fields using standard typed controls
* Project-specific product availability
* Project-specific price/visibility overrides

### Defer until later

* Complex dependent option rules
* Full swatch/image selector behaviour
* Advanced reusable option-set manager
* Deep stock control per variation
* Bulk product editor
* Conditional pricing logic
* Supplier-facing production automation

---

## The key lesson from Ecwid

The strongest pattern to borrow is this:

> **Do not create a separate product for every possible buying choice. Create a stable product, then attach structured options to it. Promote an option combination to a variation only when it needs its own SKU, stock, image, weight or fixed price.**

For FUND, that keeps the catalogue clean, supports personalised fundraising products, protects order history, and gives you enough flexibility for AMOW-style seasonal campaigns, club/league catalogues, and future suppliers.

[1]: https://support.ecwid.com/hc/en-us/articles/207099959-Product-options "Product options – Ecwid Help Center"
[2]: https://docs.ecwid.com/api-reference/rest-api/products/create-product "Create product | REST API Reference | Ecwid Documentation"
[3]: https://support.ecwid.com/hc/en-us/articles/207100299-Product-variations "Product variations – Ecwid Help Center"
[4]: https://support.ecwid.com/hc/en-us/articles/7286612490140-Creating-advanced-product-options "Creating advanced product options – Ecwid Help Center"
