/// <summary>
/// Implements the API objects and logic for the Hotglue ↔ Business Central integration.
/// </summary>
/// <remarks>
/// This module exposes calculated inventory data per item, variant, and location.
/// Includes FlowField extensions, queries, and API pages for synchronization with Hotglue ETL.
/// </remarks>
namespace Hotglue.BusinessCentral.Inventory;

using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Item;

/// <summary>
/// Query that retrieves the latest item ledger entry number
/// for each combination of Item, Variant, and Location.
/// </summary>
/// <remarks>
/// This query groups all entries from the <c>Item Ledger Entry</c> table
/// and calculates the highest <c>Entry No.</c> per unique combination
/// of <c>Item No.</c>, <c>Variant Code</c>, and <c>Location Code</c>.  
/// It also joins the related Item and Item Variant records to include
/// their descriptions and system identifiers.
/// </remarks>
query 50100 "Last Entry By IVL"
{
    Caption = 'Last Entry By IVL Query';

    elements
    {
        /// <summary>
        /// Main DataItem that reads entries from the "Item Ledger Entry" table.
        /// </summary>
        dataitem(ItemEntries; "Item Ledger Entry")
        {
            /// <summary>
            /// The unique item number associated with the ledger entry.
            /// </summary>
            column(ItemNo; "Item No.") { }
            /// <summary>
            /// The code of the variant for the item.
            /// </summary>
            column(VariantCode; "Variant Code") { }
            /// <summary>
            /// The warehouse or location code where the entry was recorded.
            /// </summary>
            column(LocationCode; "Location Code") { }

            /// <summary>
            /// The latest ledger entry number for the given Item/Variant/Location combination.
            /// </summary>
            /// <remarks>
            /// Uses the <c>Max</c> method to retrieve the highest "Entry No."
            /// representing the most recent transaction for that combination.
            /// </remarks>
            column(LastEntryNo; "Entry No.") { Method = Max; }

            /// <summary>
            /// Linked DataItem that retrieves additional information about the item.
            /// </summary>
            dataitem(Item; Item)
            {
                DataItemLink = "No." = ItemEntries."Item No.";

                /// <summary>
                /// The description of the item.
                /// </summary>
                column(ItemDescription; Description) { }

                /// <summary>
                /// The system identifier (GUID) of the item.
                /// </summary>
                column(ItemId; SystemId) { }

                /// <summary>
                /// Nested DataItem that retrieves the corresponding item variant.
                /// </summary>
                dataitem(ItemVariant; "Item Variant")
                {
                    DataItemLink = "Item No." = Item."No.", Code = ItemEntries."Variant Code";

                    /// <summary>
                    /// The system identifier (GUID) of the item variant.
                    /// </summary>
                    column(VariantId; SystemId) { }
                }
            }
        }
    }
}