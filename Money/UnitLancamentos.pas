unit UnitLancamentos;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FireDAC.comp.Client, FireDAC.DApt, FMX.ListView, Data.DB, DateUtils;

type
  TFFLancamentos = class(TForm)
    Layout17: TLayout;
    lblLancamento: TLabel;
    Layout1: TLayout;
    Layout2: TLayout;
    Layout3: TLayout;
    Layout4: TLayout;
    imgAnt: TImage;
    imgProx: TImage;
    Image3: TImage;
    lvLancamento: TListView;
    imgCategoria: TImage;
    Rectangle1: TRectangle;
    lblMes: TLabel;
    btnAdd: TImage;
    Layout6: TLayout;
    Layout7: TLayout;
    Layout8: TLayout;
    lblReceita: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    lblDespesas: TLabel;
    Label5: TLabel;
    lblSaldo: TLabel;
    Layout9: TLayout;
    btnVoltarConta: TImage;
    procedure FormShow(Sender: TObject);
    procedure lvLancamentoUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure btnVoltaContaClick(Sender: TObject);
    procedure lvLancamentoItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure btnAddClick(Sender: TObject);
    procedure imgProxClick(Sender: TObject);
    procedure imgAntClick(Sender: TObject);

  private
    dtFiltro : TDate;
    procedure EditarLancamento(idLancamento: String);
    procedure ListarLancamentos;
    procedure NavegarMes(nuMes: integer);
    function NomeMes: string;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FFLancamentos: TFFLancamentos;

implementation

{$R *.fmx}
{$R *.LgXhdpiTb.fmx ANDROID}
{$R *.XLgXhdpiTb.fmx ANDROID}

uses UnitPrincipal, UnitLancamentoNovo, cLancamento, UnitDM;

procedure TFFLancamentos.btnAddClick(Sender: TObject);
begin
   EditarLancamento('');
end;

procedure TFFLancamentos.btnVoltaContaClick(Sender: TObject);
begin
   close;
end;

procedure TFFLancamentos.NavegarMes(nuMes: integer);
begin
   dtFiltro := IncMonth(dtFiltro,nuMes);
   lblMes.Text := NomeMes;
   ListarLancamentos;
end;

function TFFLancamentos.NomeMes() : string;
begin
   case MonthOf(dtFiltro) of
      1: Result := 'Janeiro';
      2: Result := 'Fevereiro';
      3: Result := 'Março';
      4: Result := 'Abril';
      5: Result := 'Maio';
      6: Result := 'Junho';
      7: Result := 'Julho';
      8: Result := 'Agosto';
      9: Result := 'Setembro';
      10: Result := 'Outubro';
      11: Result := 'Novembro';
      12: Result := 'Dezembro';
   end;

   Result := Result + ' / ' + YearOf(dtFiltro).ToString;
end;

procedure TFFLancamentos.ListarLancamentos;
var
   foto : TStream;
   lanc : TLancamento;
   qry : TFDQuery;
   erro : string;
   vlRec, vlDesp: double;
begin

   try
      FFLancamentos.lvLancamento.Items.Clear;
      vlRec := 0;
      vlDesp := 0;

      lanc := TLancamento.Create(dm.conn);
      lanc.DATA_DE := FormatDateTime('YYYY-MM-DD',StartOfTheMonth(dtFiltro));
      lanc.DATA_ATE := FormatDateTime('YYYY-MM-DD',EndOfTheMonth(dtFiltro));
      qry := lanc.ListarLancamento(0, erro);

      if erro <> '' then
      begin
         ShowMessage(erro);
         Exit;
      end;

      while not qry.Eof do
      begin
         if qry.FieldByName('ICONE').AsString <> '' then
            foto := qry.CreateBlobStream(qry.FieldByName('ICONE'), TBlobStreamMode.bmRead)
         else
            foto := nil;

         FPrincipal.AddLancamento(FFLancamentos.lvLancamento,
                       qry.FieldByName('ID_LANCAMENTO').AsString,
                       qry.FieldByName('DESCRICAO').AsString,
                       qry.FieldByName('DESCRICAO_CATEGORIA').AsString,
                       qry.FieldByName('DATA').AsDateTime,
                       qry.FieldByName('VALOR').AsFloat,
                       foto);
         //Soma da Despesa ou Receita
         if qry.FieldByName('VALOR').AsFloat > 0 then
            vlRec := vlRec + qry.FieldByName('VALOR').AsFloat
         else
            vlDesp := vlDesp + qry.FieldByName('VALOR').AsFloat;


         qry.Next;

         foto.DisposeOf;
      end;
      //Preenche os Label
      lblReceita.Text := FormatFloat('R$#,##0.00', vlRec);
      lblDespesas.Text := FormatFloat('R$#,##0.00', vlDesp);
      lblSaldo.Text := FormatFloat('R$#,##0.00', vlRec + vlDesp); //Somando Receita positiva com Despesa negativa
   finally
      lanc.DisposeOf;
   end;

   foto := TMemoryStream.Create;
   imgCategoria.Bitmap.SaveToStream(foto);
   foto.Position := 0;

   foto.DisposeOf;
end;

procedure TFFLancamentos.FormShow(Sender: TObject);
begin
   dtFiltro := Date;
   NavegarMes(0);
end;

procedure TFFLancamentos.imgAntClick(Sender: TObject);
begin
   NavegarMes(-1);
end;

procedure TFFLancamentos.imgProxClick(Sender: TObject);
begin
   NavegarMes(1);
end;

procedure TFFlancamentos.EditarLancamento(idLancamento: String);
begin
   if not Assigned(FFLancamentoNovo) then
      Application.CreateForm(TFFLancamentoNovo, FFLancamentoNovo);

   if idLancamento <> '' then
   begin
      FFLancamentoNovo.modo := 'A';
      FFLancamentoNovo.idlanc := idLancamento.ToInteger;

   end
   else
   begin
      FFLancamentoNovo.modo := 'I';
      FFLancamentoNovo.idlanc := 0;
   end;

   FFLancamentoNovo.ShowModal(procedure(ModalResult: TmodalResult)
      begin
         ListarLancamentos;
      end);
end;

procedure TFFLancamentos.lvLancamentoItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
   EditarLancamento(AItem.TagString);
end;

procedure TFFLancamentos.lvLancamentoUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
   FPrincipal.SetupLancamento(lvLancamento ,AItem);
end;

end.
