/// <summary>
/// PageExtension KNH Sales Order (ID 51700) extends Record Sales Order.
/// Dimension table = 9 fields (Code, Code Name, Code Caption, Filter Caption, Description, Blocked, 
///                   Consolidation Date, Map-to IC Dim code, Last Mod DT)
/// Dim Value table = 13 fields (Dim Code, Code, Name, Dim Value Type, Totlalling, Blocked, Consol Code, Indent, Global Dim No., 
///                    Map-to IC Dim Code, Map-to IC dim Value Code, dim Value Id, Id, Last Mod DT, Dim Id)
/// Dim Set Entry = 7 fields (Dim Set Id, Dim Code, Dim Value Code, Dim Value ID, Dim Name, Dim Value Name, Global Dim No.)
/// Notes: Global Dim No. = General Ledger Setup table
///        Dim Value code, Dim Value Id, Dim Value Name = Dim Value table
///        Dim Code = Dimension table
///        Only Dim Set Id does not belong to another table
/// </summary>
pageextension 51700 "KNH_SalesOrder" extends "Sales Order"
{
    actions
    {
        addfirst(Processing)
        {
            action("KNH_KNH DimTest")
            {
                Caption = 'Create Dimensions';
                ApplicationArea = Basic, Suite;
                ToolTip = 'Create Dimensions.';
                Image = DimensionSets;
                //assumption that SH record contain a dim set id value

                trigger OnAction() //create new dim value rec and SH Dim Set Entry rec
                var
                    Dimension: Record "Dimension";
                    DimensionValue: Record "Dimension Value";
                    DimensionSetEntry: Record "Dimension Set Entry";
                    DimValue: array[10] of Code[20];
                    DimCode: array[10] of Code[20];
                    I: Integer;
                begin
                    DimCode[1] := 'PROJECT';
                    DimValue[1] := 'KNH Project';
                    DimCode[2] := 'DEPARTMENT';
                    DimValue[2] := 'SALES';

                    for I := 1 to 2 do begin
                        //Create dim if need be
                        if not Dimension.Get(DimCode[I]) then begin
                            Dimension.Init();
                            Dimension.Code := 'PROJECT';
                            Dimension.Insert(true);
                        end;

                        //Create dim value record if need be
                        if not DimensionValue.Get(Dimension.Code, DimValue[1]) then begin
                            DimensionValue.Init();
                            DimensionValue.Validate("Dimension Code", Dimension.Code);
                            DimensionValue.Validate("Code", DimValue[I]);
                            DimensionValue.Validate(Name, DimValue[I]);
                            DimensionValue.Insert(true); //Generates Dim value id
                        end;

                        //Create dim set entry record if need be
                        if not DimensionSetEntry.Get(Rec."Dimension Set ID", Dimension.Code) then begin
                            DimensionSetEntry.Init();
                            DimensionSetEntry.Validate("Dimension Set ID", Rec."Dimension Set ID");
                            DimensionSetEntry.Validate("Dimension Code", Dimension.Code);
                            DimensionSetEntry.Validate("Dimension Value Code", DimensionValue.Code);
                            DimensionSetEntry.Insert(true);
                        end;
                    end;
                end;
            }
        }
    }
}
