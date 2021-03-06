unit testbrookhttpclient;

{$mode objfpc}{$H+}

interface

uses
  BrookHTTPClient, BrookFCLHTTPClientBroker, fpcunit, testregistry;

const
  URL = 'http://brookframework.org/humans.txt';
  LIB = 'fclweb';
  OK = 200;
  SOK = 'OK';
  GET = 'GET';

type
  TTestBrookHTTPClient = class(TTestCase)
  published
    procedure TestClient;
    procedure TestHttpDef;
  end;

implementation

procedure TTestBrookHTTPClient.TestClient;
var
  VClient: TBrookHTTPClient;
  VResult: TBrookHTTPResult;
begin
  VClient := TBrookHTTPClient.Create(LIB);
  try
    VResult := VClient.Request(URL);
    AssertEquals(SOK, VResult.ReasonPhrase);
    AssertEquals(OK, VResult.StatusCode);
    AssertEquals(True, Length(VResult.Content) > 0);
  finally
    VClient.Free
  end;
end;

procedure TTestBrookHTTPClient.TestHttpDef;
var
  VClient: TBrookHTTPClient;
  VHttp: TBrookHTTPDef = nil;
  VResult: TBrookHTTPResult;
begin
  VClient := TBrookHTTPClient.Create(LIB);
  try
    VClient.Prepare(VHttp);
    VHttp.Method := GET;
    VHttp.Url := URL;
    VResult := VClient.Request(VHttp);
    AssertEquals(SOK, VResult.ReasonPhrase);
    AssertEquals(OK, VResult.StatusCode);
    AssertEquals(True, Length(VResult.Content) > 0);
    AssertEquals(True, VHttp.Contents.Count > 0);
    AssertEquals(True, VHttp.Document.Size > 0);
    AssertEquals(True, VHttp.Cookies.Count = 0);
  finally
    VHttp.Free;
    VClient.Free
  end;
end;

initialization
  RegisterTest(TTestBrookHTTPClient);

end.

