page 82100 "WaldoNAVPad"
{
    Caption = 'WaldoNAVPad - Simplified';
    PageType = Card;

    layout
    {
        area(content)
        {
            usercontrol(MyUserControl; "Microsoft.Dynamics.Nav.Client.WebPageViewer")
            {
                ApplicationArea = All;
                trigger ControlAddInReady(callbackUrl: Text)
                begin
                    IsReady := true;
                    FillAddIn();
                end;

                trigger Callback(data: Text)
                begin
                    FullText := data;
                end;
            }

            //Cheap Fix: 
            //Without this, the page's caption will not be displayed. It serves no other purpose.
            grid(Control1100084005)
            {
                field(CaptionDummy; '')
                {
                    Visible = false;
                    ShowCaption = false;
                    ApplicationArea = All;
                }
            }
        }
    }


    var
        FullText: Text;
        IsReady: Boolean;

    procedure SetText(Value: Text);
    begin
        FullText := Value;
    end;

    procedure GetText(): Text;
    begin
        exit(FullText);
    end;

    local procedure FillAddIn()
    begin
        CurrPage.MyUserControl.SetContent(StrSubstNo('<textarea Id="TextArea" maxlength="%2" style="width:100%;height:100%;resize: none; font-family:Segoe UI Segoe WP, Segoe, device-segoe, Tahoma, Helvetica, Arial, sans-serif; font-size: 12pt;" OnChange="window.parent.WebPageViewerHelper.TriggerCallback(document.getElementById(''TextArea'').value)">%1</textarea>', FullText, 4096));
    end;
}

