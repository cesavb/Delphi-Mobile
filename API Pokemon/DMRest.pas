unit DMRest;

interface

uses
  System.SysUtils, System.Classes, REST.Types, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, System.Threading, System.Net.URLClient,
  System.Net.HttpClient, System.Net.HttpClientComponent;

type
  TdmPok = class(TDataModule)
    RESTClient: TRESTClient;
    RESTRequest: TRESTRequest;
    RESTResponse: TRESTResponse;
  private
    { Private declarations }
  public

    { Public declarations }
  end;

var
  dmPok: TdmPok;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
