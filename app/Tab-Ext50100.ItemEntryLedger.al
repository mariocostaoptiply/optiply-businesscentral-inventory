/// <summary>
/// Implements the API objects and logic for the Hotglue ↔ Business Central integration.
/// </summary>
/// <remarks>
/// This module exposes calculated inventory data per item, variant, and location.
/// Includes FlowField extensions, queries, and API pages for synchronization with Hotglue ETL.
/// </remarks>
namespace Hotglue.BusinessCentral.Inventory;

using Microsoft.Inventory.Ledger;

/// <summary>
/// Extends the "Item Ledger Entry" table to include a FlowField
/// that calculates the current stock quantity per combination of Item, Variant, and Location.
/// </summary>
/// <remarks>
/// The <c>Stock By IVL</c> FlowField sums the "Remaining Quantity" from all ledger entries
/// matching the same Item No., Variant Code, and Location Code.
/// This allows for efficient retrieval of stock levels grouped by these dimensions
/// without requiring external queries or code calculations.
/// </remarks>
tableextension 50102 "Entry Ledger Stock IVL" extends "Item Ledger Entry"
{
    fields
    {
        field(50100; "Stock By IVL"; Decimal)
        {
            Caption = 'Item Entry Ledger Stock by IVL';
            FieldClass = FlowField;
            CalcFormula = Sum("Item Ledger Entry"."Remaining Quantity"
                              WHERE("Item No." = FIELD("Item No."),
                                    "Variant Code" = FIELD("Variant Code"),
                                    "Location Code" = FIELD("Location Code")));
            Editable = false;
        }
    }
}
