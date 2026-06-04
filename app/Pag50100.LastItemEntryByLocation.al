/// <summary>
/// Implements the API objects and logic for the Optiply ↔ Business Central integration.
/// </summary>
/// <remarks>
/// This module exposes calculated inventory data per item, variant, and location.
/// Includes FlowField extensions, queries, and API pages for synchronization with Optiply ETL.
/// </remarks>
namespace Optiply.BusinessCentral.Inventory;

using Microsoft.Inventory.Ledger;

/// <summary>
/// API page that exposes calculated inventory quantities per Item, Variant, and Location.
/// </summary>
/// <remarks>
/// This page serves as an integration endpoint to retrieve current stock information
/// grouped by Item, Variant, and Location.  
/// It builds its dataset dynamically using the <c>Last Entry By IVL</c> query and
/// the <c>Stock By IVL</c> FlowField from the "Item Ledger Entry" table.  
/// The data is populated into the temporary table <c>Temp Stock by IVL</c>
/// and made available through an OData/REST API endpoint for external integrations
/// such as Optiply.
/// </remarks>
page 70200000 "Inventory Location Query"
{

    Caption = 'Inventory By Location    ';
    SourceTable = "Temp Stock by IVL";
    ApplicationArea = All;
    UsageCategory = Lists;

    PageType = API;
    APIPublisher = 'optiply';
    APIGroup = 'integration';
    APIVersion = 'v1.0';
    EntityName = 'inventoryByLocation';
    EntitySetName = 'inventoryByLocations';
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                /// <summary>
                /// System identifier (GUID) of the parent item.
                /// </summary>
                field(ItemId; Rec."Parent Id")
                {
                    ApplicationArea = All;
                }

                /// <summary>
                /// Item number of the product.
                /// </summary>
                field(ItemNo; Rec."Item No.")
                {
                    ApplicationArea = All;
                }

                /// <summary>
                /// System identifier (GUID) of the variant.
                /// </summary>
                field(VariantId; Rec."Variant Id")
                {
                    ApplicationArea = All;
                }

                /// <summary>
                /// Variant code of the product.
                /// </summary>
                field(VariantCode; Rec."Variant Code")
                {
                    ApplicationArea = All;
                }

                /// <summary>
                /// Code of the warehouse or location where the item is stored.
                /// </summary>
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = All;
                }

                /// <summary>
                /// Date and time when the source ledger entry was last modified.
                /// </summary>
                field(SystemModifiedAt; Rec."SystemModifiedAt")
                {
                    ApplicationArea = All;
                }

                /// <summary>
                /// Calculated inventory quantity for this Item/Variant/Location combination.
                /// </summary>
                field(Inventory; Rec."Inventory")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    /// <summary>
    /// Trigger executed when the API page is opened.  
    /// It populates the temporary table <c>Temp Stock by IVL</c> with
    /// the latest inventory data per Item, Variant, and Location.
    /// </summary>
    /// <remarks>
    /// This trigger runs the <c>Last Entry By IVL</c> query to find the most recent
    /// item ledger entry for each Item/Variant/Location combination.  
    /// It then retrieves the corresponding record, calculates the <c>Stock By IVL</c>
    /// FlowField, and inserts the aggregated result into the temporary table.
    /// </remarks>
    trigger OnOpenPage()
    var
        QLastEntry: Query "Last Entry By IVL";
        ItemLedger: Record "Item Ledger Entry";
    begin
        if QLastEntry.Open() then begin
            while QLastEntry.Read() do begin
                if ItemLedger.Get(QLastEntry.LastEntryNo) then begin
                    ItemLedger.CalcFields("Stock By IVL"); // Calc Flowfield for this Entry
                    Rec.Init();
                    Rec.RowNo += 1;
                    Rec."Parent Id" := QLastEntry.ItemId;
                    Rec."Item No." := QLastEntry.ItemNo;
                    Rec."Variant Id" := QLastEntry.VariantId;
                    Rec."Variant Code" := QLastEntry.VariantCode;
                    Rec."Location Code" := QLastEntry.LocationCode;
                    Rec."SystemModifiedAt" := ItemLedger."SystemModifiedAt";
                    Rec."Inventory" := ItemLedger."Stock By IVL";
                    Rec.Insert();
                end;
            end;
            QLastEntry.Close();
        end;
    end;
}
