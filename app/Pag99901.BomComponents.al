/// <summary>
/// Implements the API objects and logic for the Optiply ↔ Business Central integration.
/// </summary>
/// <remarks>
/// This module exposes Assembly BOM component lines for synchronization with Optiply ETL.
/// </remarks>
namespace Optiply.BusinessCentral.Inventory;

using Microsoft.Inventory.BOM;

/// <summary>
/// API page that exposes Assembly BOM component lines.
/// </summary>
/// <remarks>
/// This page serves as an integration endpoint to retrieve the component items,
/// quantities, units of measure, and modification timestamps for assembled parent items.
/// </remarks>
page 99901 "BOM Components API"
{
    PageType = API;
    Caption = 'BOM Components API';

    APIPublisher = 'optiply';
    APIGroup = 'integration';
    APIVersion = 'v1.0';

    EntityName = 'bomComponent';
    EntitySetName = 'bomComponents';

    SourceTable = "BOM Component";
    ODataKeyFields = SystemId;

    Extensible = false;
    DelayedInsert = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                /// <summary>
                /// System identifier (GUID) of the BOM component line.
                /// </summary>
                field(id; Rec.SystemId)
                {
                    ApplicationArea = All;
                    Caption = 'Id';
                    Editable = false;
                }

                /// <summary>
                /// Parent assembled item number.
                /// </summary>
                field(parentItemNo; Rec."Parent Item No.")
                {
                    ApplicationArea = All;
                    Caption = 'Parent Item No.';
                    Editable = false;
                }

                /// <summary>
                /// Line number of the component within the parent BOM.
                /// </summary>
                field(lineNo; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Caption = 'Line No.';
                    Editable = false;
                }

                /// <summary>
                /// BOM component type, such as Item or Resource.
                /// </summary>
                field(componentType; Rec.Type)
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                    Editable = false;
                }

                /// <summary>
                /// Component item/resource number.
                /// </summary>
                field(no; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'No.';
                    Editable = false;
                }

                /// <summary>
                /// Component line description.
                /// </summary>
                field(description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    Editable = false;
                }

                /// <summary>
                /// Quantity of the component required per parent item.
                /// </summary>
                field(quantityPer; Rec."Quantity per")
                {
                    ApplicationArea = All;
                    Caption = 'Quantity per';
                    Editable = false;
                }

                /// <summary>
                /// Unit of measure used by the component line.
                /// </summary>
                field(unitOfMeasureCode; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    Caption = 'Unit of Measure Code';
                    Editable = false;
                }

                /// <summary>
                /// Position value for stable ordering/debugging.
                /// </summary>
                field(position; Rec.Position)
                {
                    ApplicationArea = All;
                    Caption = 'Position';
                    Editable = false;
                }

                /// <summary>
                /// Variant code on the BOM component line.
                /// </summary>
                field(variantCode; Rec."Variant Code")
                {
                    ApplicationArea = All;
                    Caption = 'Variant Code';
                    Editable = false;
                }

                /// <summary>
                /// Date and time when the BOM component line was created.
                /// </summary>
                field(systemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    Caption = 'System Created At';
                    Editable = false;
                }

                /// <summary>
                /// Date and time when the BOM component line was last modified.
                /// </summary>
                field(systemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = All;
                    Caption = 'System Modified At';
                    Editable = false;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.ReadIsolation := IsolationLevel::ReadCommitted;
    end;
}
