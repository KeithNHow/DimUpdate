/* 
<summary>
PageExtension KNH Sales Order (ID 51700) extends Record Sales Order.
Dimension table = 9 fields, Dim Value table = 13 fields , Dim Set Entry = 7 fields 
Action on Sales Order page to create Dimension, Dim Value and Dim Set Entry records based on the Dim Set ID on the Sales Order header. This is sample code to illustrate how to create dimension related records from a sales order page extension. The actual implementation may vary based on the specific requirements and design considerations.
</summary> 
*/
pageextension 51700 KNHSalesOrder extends "Sales Order"
{
    actions
    {
        addfirst(processing)
        {
            action("KNH_KNH DimTest")
            {
                Caption = 'Create Dimensions';
                ApplicationArea = Basic, Suite;
                ToolTip = 'Create Dimensions.';
                Image = DimensionSets;

                trigger OnAction()
                var
                    Dimension: Record Dimension;
                    DimensionSetEntry: Record "Dimension Set Entry";
                    DimensionValue: Record "Dimension Value";
                    DimCode: array[10] of Code[20];
                    DimValue: array[10] of Code[20];
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
