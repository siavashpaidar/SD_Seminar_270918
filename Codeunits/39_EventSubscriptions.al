codeunit 123456739 EventSubscriptions
// CSD1.00 - 2018-01-01 - D. E. Veloper
// Chapter 7 - Lab 2-1
{
    [EventSubscriber(ObjectType::Page, 344, 'OnAfterNavigateFindRecords', '', true, true)]

    local procedure ExtendNavigateOnAfterNavigateFindRecords(var DocumentEntry: Record "Document Entry";
    DocNoFilter: Text;
    PostingDateFilter: Text);
    var
        SeminarLedgerEntry: Record "CSD Seminar Ledger Entry";
        PostedSeminarRegHeader: Record "CSD Posted Seminar Reg. Header";
        DocNoOfRecords: Integer;
        NextEntryNo: Integer;
    begin
        if PostedSeminarRegHeader.ReadPermission then begin
            PostedSeminarRegHeader.Reset;
            PostedSeminarRegHeader.SetFilter("No.", DocNoFilter);
            PostedSeminarRegHeader.SetFilter("Posting Date", PostingDateFilter);
            DocNoOfRecords := PostedSeminarRegHeader.Count;
            with DocumentEntry do
            begin
                if DocNoOfRecords = 0 then
                    exit;
                if FindLast then
                    NextEntryNo := "Entry No." + 1
                else
                    NextEntryNo := 1;
                Init;
                "Entry No." := NextEntryNo;
                "Table ID" := Database::"CSD Posted Seminar Reg. Header";
                "Document Type" := 0;
                "Table Name" := CopyStr(PostedSeminarRegHeader.TableCaption, 1, MaxStrLen("Table Name"));
                "No. of Records" := DocNoOfRecords;
                Insert;
            end;
            if SeminarLedgerEntry.ReadPermission then begin
                SeminarLedgerEntry.Reset;
                SeminarLedgerEntry.SetFilter("Document No.", DocNoFilter);
                SeminarLedgerEntry.SetFilter("Posting Date", PostingDateFilter);
                DocNoOfRecords := SeminarLedgerEntry.Count;
                with DocumentEntry do
                begin
                    if DocNoOfRecords = 0 then
                        exit;
                    if FindLast then
                        NextEntryNo := "Entry No." + 1
                    else
                        NextEntryNo := 1;
                    Init;
                    "Entry No." := NextEntryNo;
                    "Table ID" := Database::"CSD Posted Seminar Reg. Header";
                    "Document Type" := 0;
                    "Table Name" := CopyStr(SeminarLedgerEntry.TableCaption, 1, MaxStrLen("Table Name"));
                    "No. of Records" := DocNoOfRecords;
                    Insert;
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, 344, 'OnAfterNavigateShowRecords', '', true, true)]
    local procedure ExtendNavigateOnAfterNavigateShowRecords(TableID: Integer;
    DocNoFilter: Text;
    PostingDateFilter: Text;
    ItemTrackingSearch: Boolean);

    var
        SeminarLedgerEntry: Record "CSD Seminar Ledger Entry";
        PostedSeminarRegHeader: Record "CSD Posted Seminar Reg. Header";

    begin
        case TableID of
      Database::"CSD Posted Seminar Reg. Header" :
        begin
            PostedSeminarRegHeader.SetFilter("No.", DocNoFilter);
            PostedSeminarRegHeader.SetFilter("Posting Date", PostingDateFilter);
            Page.Run(0, PostedSeminarRegHeader);
        end;
        Database::"CSD Seminar Ledger Entry" :
        begin
            SeminarLedgerEntry.SetFilter("Document No.", DocNoFilter);
            SeminarLedgerEntry.SetFilter("Posting Date", PostingDateFilter);
            Page.Run(0, SeminarLedgerEntry);
        end;

        end;
    end;

}
