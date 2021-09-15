unit UnitLancamentoNovo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit, UnitPrincipal,
  FMX.DateTimeCtrls, FMX.ListBox, FireDAC.Comp.Client, FireDAC.DApt, FMX.DialogService;

type
  TFFLancamentoNovo = class(TForm)
    Layout5: TLayout;
    lblNewDespesa: TLabel;
    Layout4: TLayout;
    btnDelete: TRectangle;
    imgDelete: TImage;
    Label1: TLabel;
    edtDesc: TEdit;
    Line1: TLine;
    Layout1: TLayout;
    Label2: TLabel;
    edtValor: TEdit;
    Line2: TLine;
    Layout2: TLayout;
    Label3: TLabel;
    Layout3: TLayout;
    Label4: TLabel;
    dtData: TDateEdit;
    btnHoje: TImage;
    btnOntem: TImage;
    Line4: TLine;
    btnVoltarConta: TImage;
    imgSalve: TImage;
    imgTpLanc: TImage;
    imgDesp: TImage;
    imgRec: TImage;
    cbCat: TComboBox;
    imgCat: TImage;
    procedure btnVoltaContaClick(Sender: TObject);
    procedure imgTpLancClick(Sender: TObject);
    procedure imgCatClick(Sender: TObject);
    procedure btnHojeClick(Sender: TObject);
    procedure btnOntemClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure imgSalveClick(Sender: TObject);
    procedure edtValorTyping(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure imgDeleteClick(Sender: TObject);
  private
    procedure ComboCategoria;
    { Private declarations }
  public
    { Public declarations }
    modo : string; // I (Inclusão) ou A (Alteração)
    idlanc : Integer;
  end;

var
  FFLancamentoNovo: TFFLancamentoNovo;

implementation

{$R *.fmx}

uses UnitCategorias, cCategoria, UnitDM, cLancamento, uFormat;

procedure TFFLancamentoNovo.ComboCategoria;
var
   c : TCategoria;
   erro : string;
   qry : TFDQuery;
begin

   try
      cbCat.Items.Clear;

      c := TCategoria.Create(dm.conn);
      qry := c.ListarCategoria(erro);

      if erro <> '' then
      begin
         ShowMessage(erro);
         exit;
      end;
      while not qry.Eof do
      begin
         cbCat.Items.AddObject(qry.FieldByName('DESCRICAO').AsString,
                               TObject(qry.FieldByName('ID_CATEGORIA').AsInteger));

         qry.Next;
      end;

   finally
      c.DisposeOf;
      qry.DisposeOf
   end;

end;

procedure TFFLancamentoNovo.edtValorTyping(Sender: TObject);
begin
   Formatar(edtValor, TFormato.Valor);
end;

procedure TFFLancamentoNovo.FormShow(Sender: TObject);
var
   lanc : TLancamento;
   qry : TFDQuery;
   erro : string;
begin
   ComboCategoria;



   if modo = 'I' then
   begin
      edtDesc.Text := '';
      dtData.Date := now;
      edtValor.Text := '';
      imgTpLanc.Bitmap := imgDesp.Bitmap;
      imgTpLanc.Tag := -1;
      btnDelete.Visible := false;
   end
   else
   begin
      try
         lanc := TLancamento.Create(dm.conn);
         lanc.ID_LANCAMENTO := idLanc;
         qry := lanc.ListarLancamento(0, erro);
         lblNewDespesa.Text := 'Editar Despesas';
         btnDelete.Visible := true;

         if qry.RecordCount = 0 then
         begin
            ShowMessage('Lançamento não encontrado.');
            exit;
         end;

         edtDesc.Text := qry.FieldByName('DESCRICAO').AsString;
         dtData.Date := qry.FieldByName('DATA').AsDateTime;

         if qry.FieldByName('VALOR').AsFloat < 0 then // Se for Despesa
         begin
            edtValor.Text := FormatFloat('R$#,##00.00', qry.FieldByName('VALOR').AsFloat * -1);
            imgTpLanc.Bitmap := imgDesp.Bitmap;
            imgTpLanc.Tag := -1;
         end
         else
         begin
            edtValor.Text := FormatFloat('R$#,##00.00', qry.FieldByName('VALOR').AsFloat);
            imgTpLanc.Bitmap := imgRec.Bitmap;
            imgTpLanc.Tag := 1;
         end;

         cbCat.ItemIndex := cbCat.Items.IndexOf(qry.FieldByName('DESCRICAO_CATEGORIA').AsString);

      finally
         qry.DisposeOf;
         lanc.DisposeOf;
      end;
   end;
end;

function TrataValor(str: string): Double;
begin
   str := StringReplace(str, '.', '', [rfReplaceAll]); //Retirando os '.'
   str := StringReplace(str, ',', '', [rfReplaceAll]); //Retirando as ','

   try
      Result := StrToFloat(str) / 100;
   Except
      result := 0;
   end;
end;

procedure TFFLancamentoNovo.imgSalveClick(Sender: TObject);
var
   lanc : TLancamento;
   qry : TFDQuery;
   erro : string;
begin
   try
      lanc := TLancamento.Create(dm.conn);
      lanc.DESCRICAO := edtDesc.Text;
      lanc.VALOR := TrataValor(edtValor.Text) * imgTpLanc.Tag;
      lanc.ID_CATEGORIA := integer(cbCat.Items.Objects[cbCat.ItemIndex]);
      lanc.DATA := dtData.Date;

      if modo = 'I' then
      begin
         lanc.Inserir(erro)
      end
      else
      begin
         lanc.ID_LANCAMENTO := idlanc;
         lanc.Alterar(erro);
      end;

      if erro <>'' then
      begin
         ShowMessage(erro);
         exit;
      end;

      close;

   finally
      lanc.DisposeOf;
   end;

end;

procedure TFFLancamentoNovo.imgCatClick(Sender: TObject);
begin
   if not Assigned(FFCategoria) then
      Application.CreateForm(TFFCategoria, FFCategoria);

   FFCategoria.Show;
end;

procedure TFFLancamentoNovo.imgTpLancClick(Sender: TObject);
begin
   if imgTpLanc.Tag = 1 then
   begin
      imgTpLanc.Bitmap := imgDesp.Bitmap;
      imgTpLanc.Tag := -1;
   end
   else
   begin
      imgTpLanc.Bitmap := imgRec.Bitmap;
      imgTpLanc.Tag := 1;
   end;
end;

procedure TFFLancamentoNovo.btnDeleteClick(Sender: TObject);
var
   lanc: TLancamento;
   erro: string;
begin
   TDialogService.MessageDialog('Confirma a exclusão da Lançamento?',
                                TMsgDlgType.mtConfirmation,
                                [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
                                TMsgDlgBtn.mbNo,
                                0,
   procedure(const AResult: TModalResult)
   var
      erro: string;
   begin
     if AResult = mrYes then
     begin
        Lanc := TLancamento.Create(dm.conn);
        try
           Lanc.ID_Lancamento := idlanc;
           if Lanc.Excluir(erro) = False then
           begin
              ShowMessage(erro);
              exit;
           end;

           close;
        finally
           Lanc.DisposeOf;
        end;
     end;
   end);
end;

procedure TFFLancamentoNovo.imgDeleteClick(Sender: TObject);
var
   lanc: TLancamento;
   erro: string;
begin
   TDialogService.MessageDialog('Confirma a exclusão da Lançamento?',
                                TMsgDlgType.mtConfirmation,
                                [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
                                TMsgDlgBtn.mbNo,
                                0,
   procedure(const AResult: TModalResult)
   var
      erro: string;
   begin
     if AResult = mrYes then
     begin
        Lanc := TLancamento.Create(dm.conn);
        try
           Lanc.ID_Lancamento := idlanc;
           if Lanc.Excluir(erro) = False then
           begin
              ShowMessage(erro);
              exit;
           end;

           close;
        finally
           Lanc.DisposeOf;
        end;
     end;
   end);
end;

procedure TFFLancamentoNovo.btnHojeClick(Sender: TObject);
begin
   dtData.Date := now;
end;

procedure TFFLancamentoNovo.btnOntemClick(Sender: TObject);
begin
   dtData.Date := now -1;
end;

procedure TFFLancamentoNovo.btnVoltaContaClick(Sender: TObject);
begin
   close;
end;

end.
