unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, REST.Types,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope, FMX.Objects, System.JSON,
  FMX.TabControl, StrUtils, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, IdSSL, IdSSLOpenSSL;

type
  TForm1 = class(TForm)
    lblCaption: TLabel;
    Layout1: TLayout;
    lvPokemon: TListView;
    TabControl1: TTabControl;
    tabPokedex: TTabItem;
    tabDados: TTabItem;
    tabSearch: TTabItem;
    Image1: TImage;
    Layout2: TLayout;
    imgPoke: TImage;
    lblDescricao: TLabel;
    Layout3: TLayout;
    procedure FormShow(Sender: TObject);
    procedure lvPokemonItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    function FormataNome(sNome: String): string;
    function ReturnImage(URL: string): TBitmap;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses DMRest;

function Tform1.FormataNome(sNome: String): string;
const
  excecao: array[0..5] of string = (' da ', ' de ', ' do ', ' das ', ' dos ', ' e ');
var
  tamanho, j: integer;
  i: byte;
begin
  Result := AnsiLowerCase(sNome);
  tamanho := Length(Result);

  for j := 1 to tamanho do
    // Se é a primeira letra ou se o caracter anterior é um espaço
    if (j = 1) or ((j>1) and (Result[j-1]=Chr(32))) then
      Result[j] := AnsiUpperCase(Result[j])[1];
  for i := 0 to Length(excecao)-1 do
    result:= StringReplace(result,excecao[i],excecao[i],[rfReplaceAll, rfIgnoreCase]);
end;

function TForm1.ReturnImage(URL: string): TBitmap;
var
   Strm : TMemoryStream;
   img : TBitmap;
begin
   dmPok.RESTRequest.Resource := '';
   dmPok.RESTClient.BaseURL := URL;
   dmPok.RESTRequest.Execute;

   Strm := TMemoryStream.Create;
   Strm.Write(dmPok.RESTResponse.RawBytes, Length(dmPok.RESTResponse.RawBytes));

   img := TBitmap.Create;
   img.LoadFromStream(strm);

   Result := img;
end;

procedure TForm1.FormShow(Sender: TObject);
var
   i : integer;
   JSONObject, JSONImage : TJSONObject;
   nome : string;
   sprite : string;
   imagem: TListItemImage;
begin
   for i := 1 to 10 do
   begin
      dmPok.RESTClient.BaseURL := 'https://pokeapi.co/api/v2';
      dmPok.RESTRequest.Resource := 'pokemon/' + IntToStr(i);
      dmPok.RESTRequest.Execute;
      JSONObject := TJSONObject.ParseJSONValue(TEncoding.UTF8.Getbytes(dmPok.RESTResponse.Content),0) as TJSONObject;
      JSONObject := JSONObject.get('species').JSONValue as TJSONObject;
      nome := JSONObject.GetValue<string>('name');
      JSONImage := TJSONObject.ParseJSONValue(TEncoding.UTF8.Getbytes(dmPok.RESTResponse.Content),0) as TJSONObject;
      JSONImage := JSONImage.Get('sprites').JSONValue as TJSONObject;
      sprite := JSONImage.GetValue<string>('front_default');

      with lvPokemon.Items.Add do
      begin
         TagString := IntToStr(i);
         TListItemText(Objects.FindDrawable('txtName')).Text := FormataNome(nome);
         imagem := TListItemImage(Objects.FindDrawable('imgPokemon'));

         imagem.OwnsBitmap := true;
         imagem.Bitmap := ReturnImage(sprite);
      end;
   end;
end;

procedure TForm1.lvPokemonItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
   actInfo.execute;
end;

end.
