/// <summary>
/// Implements the API objects and logic for the Optiply ↔ Business Central integration.
/// </summary>
/// <remarks>
/// This module exposes calculated inventory data per item, variant, and location.
/// Includes FlowField extensions, queries, and API pages for synchronization with Optiply ETL.
/// </remarks>
namespace Optiply.BusinessCentral.Inventory;

/// <summary>
/// Temporary table that stores stock information grouped by Item, Variant, and Location.
/// </summary>
/// <remarks>
/// This table is used as an intermediate data structure for inventory calculations
/// and synchronization with external systems such as Optiply.  
/// It is defined as <c>Temporary</c>, meaning that records only exist in memory during the session.
/// Each record represents the latest entry information and aggregated inventory
/// for a specific Item/Variant/Location combination.
/// </remarks>
table 50100 "Temp Stock by IVL"
{
    Caption = 'Temp Stock by IVL Table';
    DataClassification = CustomerContent;
    TableType = Temporary;


    fields
    {
        /// <summary>
        /// Sequential row number for internal ordering and iteration.
        /// </summary>
        field(1; RowNo; Integer)
        {
            Caption = 'Row No.';
            DataClassification = CustomerContent;
        }

        /// <summary>
        /// The item number corresponding to this inventory entry.
        /// </summary>
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
        }

        /// <summary>
        /// The variant code of the item.
        /// </summary>
        field(3; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            DataClassification = CustomerContent;
        }

        /// <summary>
        /// The warehouse or location code where the item is stored.
        /// </summary>
        field(4; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            DataClassification = CustomerContent;
        }

        /// <summary>
        /// The latest item ledger entry number for this combination.
        /// </summary>    
        field(5; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }

        /// <summary>
        /// Text description of the item or variant.
        /// </summary>
        field(6; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }

        /// <summary>
        /// Timestamp of the most recent modification in the source data.
        /// </summary>
        field(7; "System Modified At"; DateTime)
        {
            Caption = 'Last Modified';
            DataClassification = CustomerContent;
        }

        /// <summary>
        /// The calculated inventory quantity for the specific Item, Variant, and Location.
        /// </summary>
        /// <remarks>
        /// Represents the aggregated stock level at variant and location level.
        /// </remarks>
        field(8; "Inventory"; Decimal)
        {
            Caption = 'Inventory (Variant + Location)';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }

        /// <summary>
        /// The system identifier (GUID) of the parent item.
        /// </summary>
        field(9; "Parent Id"; Guid)
        {
            Caption = 'Item SystemId';
            DataClassification = CustomerContent;
        }

        /// <summary>
        /// The system identifier (GUID) of the variant.
        /// </summary>
        field(10; "Variant Id"; Guid)
        {
            Caption = 'Variant SystemId';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        /// <summary>
        /// Primary key composed of Item No., Variant Code, and Location Code.
        /// </summary>
        key(PK; "Item No.", "Variant Code", "Location Code") { Clustered = true; }
    }
}
