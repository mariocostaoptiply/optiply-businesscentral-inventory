# Optiply Business Central Integration Extension

Open-source extension developed by **Optiply** to expose enriched inventory data
(Item + Variant + Location) for integration pipelines (Optiply / ETL / custom APIs).

## Features

- Custom API endpoint `/inventoryByLocations`
- Query to fetch latest Item Ledger Entry by IVL
- FlowField extension to compute inventory by IVL
- Temporary table to aggregate data
- API page providing clean and normalized output

## Build & Validation

This repository uses **GitHub AL-Go pipelines**:
- Automatic build on push
- Automatic validation (GB + W1)
- Automatic `.app` packaging
- Release pipeline on tag

## Contributing

Pull requests are welcome.  
Follow coding standards and ALDoc conventions.
