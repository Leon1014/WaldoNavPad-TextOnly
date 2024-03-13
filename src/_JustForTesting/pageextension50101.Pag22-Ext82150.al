pageextension 82150 "pageextension50101" extends "Customer List" //22
{
    actions
    {
        addfirst("&Customer")
        {
            action(OpenWaldoNAVPadText)
            {
                Caption = 'Open WaldoNAVPad Text';
                Image = Text;
                Promoted = true;
                ApplicationArea = All;

                trigger OnAction()
                var
                    WaldoNAVPadClass: Codeunit "WaldoNAVPad Class";
                begin
                    //Example code to implement the WaldoNAVPad on a Record, using the generic Text tables
                    WaldoNAVPadClass.Initialize(Rec);
                    WaldoNAVPadClass.SetTextLength(50); //Can be used to set a custom, fixed length for the saved text lines
                    WaldoNAVPadClass.ShowAndSaveTexts(true);
                end;
            }
        }
    }
}

