unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, u99Permissions,
  {$IFDEF ANDROID}
     FMX.VirtualKeyboard, FMX.Platform,
  {$ENDIF}
  FMX.StdCtrls, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, UnitLancamentos, FMX.Ani,FireDAC.comp.Client,
  FireDAC.DApt, Data.DB;

type
  TFPrincipal = class(TForm)
    Layout1: TLayout;
    imgMenu: TImage;
    imgAvatar: TCircle;
    lbl99Money: TLabel;
    imgNoti: TImage;
    imgNotiRed: TImage;
    Layout2: TLayout;
    lblSaldoAtual: TLabel;
    lblSaldo: TLabel;
    Layout3: TLayout;
    Layout4: TLayout;
    Image1: TImage;
    Image2: TImage;
    Layout5: TLayout;
    Layout6: TLayout;
    Label1: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Rectangle2: TRectangle;
    Layout7: TLayout;
    Label5: TLabel;
    lblVerTodos: TLabel;
    lvLancamento: TListView;
    imgCategoria: TImage;
    StyleBook1: TStyleBook;
    btnAddLanc: TImage;
    rectMenu: TRectangle;
    LayoutPrincipal: TLayout;
    faMenu: TFloatAnimation;
    imgFechaMenu: TImage;
    Layout8: TLayout;
    Layout9: TLayout;
    lblMenuCategoria: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lblVerTodosClick(Sender: TObject);
    procedure imgMenuClick(Sender: TObject);
    procedure lvLancamentoUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure faMenuFinish(Sender: TObject);
    procedure btnAddLancClick(Sender: TObject);
    procedure faMenuProcess(Sender: TObject);
    procedure imgFechaMenuClick(Sender: TObject);
    procedure lblMenuCategoriaClick(Sender: TObject);
    procedure lvLancamentoItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    { Private declarations }
    permissao: T99Permissions;
    procedure ListarUltLanc;
    procedure EditarLancamento(idLancamento: String);

  public
    { Public declarations }
    procedure AddLancamento(listview: TlistView; idLancamento, descricao, categoria: string;
      dt:TDateTime; valor: double; foto: Tstream);
    procedure SetupLancamento(lv: TListView; Item: TlistViewItem);
    procedure AddCategoria (listview: TlistView; idCategoria, categoria: string; foto: TStream);
    procedure SetupCategoria(lv: TlistView; Item: TlistViewItem);
  end;

var
  FPrincipal: TFPrincipal;

implementation

{$R *.fmx}

uses UnitCategorias, UnitLancamentoNovo, UnitLogin, cLancamento, cCategoria,
  UnitDM;

procedure TFPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   if Assigned(FFLancamentos) then
   begin
      FFLancamentos.DisposeOf;
      FFLancamentos := nil;
   end;
end;

procedure TFPrincipal.FormCreate(Sender: TObject);
begin
   //Unit de permissão de cãmera e galeria
   permissao := T99Permissions.Create;

   //Animação do menu
   rectMenu.Margins.Left := -200;
   rectMenu.Align        := TAlignLayout.Left;
   rectMenu.Visible      := true;

end;

//****************** UNIT FUNÇÕES GLOBAIS ******************

procedure TFPrincipal.AddLancamento (listview: TlistView; idLancamento, descricao, categoria: string; dt:TDateTime; valor: double; foto: Tstream);
var
   txt : TListItemText;
   img : TListItemImage;
   bmp : TBitmap;
begin
   with listview.Items.Add do
   begin
      TagString := idLancamento;

      //txtDescricao - Feito de uma forma
      txt := TListItemText(Objects.FindDrawable('txtDescricao'));
      txt.Text := descricao;

      //txtCategoria, valor e Data - de outra forma
      TListItemText(Objects.FindDrawable('txtCategoria')).Text := categoria;
      TListItemText(Objects.FindDrawable('txtValor')).Text := FormatFloat ('R$#,##0.00', valor);
      TListItemText(Objects.FindDrawable('txtData')).Text := FormatDateTime('dd/mm', dt);

      //Icone
      img := TListItemImage(Objects.FindDrawable('imgIcone'));

      if foto <> nil then
      begin
         bmp := TBitmap.Create;
         bmp.LoadFromStream(foto);

         img.OwnsBitmap := true;
         img.Bitmap := bmp;
      end;
   end;
end;

procedure TFPrincipal.faMenuFinish(Sender: TObject);
begin
   LayoutPrincipal.Enabled := faMenu.Inverse;
   faMenu.Inverse          := not faMenu.Inverse;
end;

procedure TFPrincipal.faMenuProcess(Sender: TObject);
begin
   LayoutPrincipal.Margins.Right := -200 - rectMenu.Margins.Left;
end;

procedure TFPrincipal.SetupLancamento(lv: TListView; Item: TlistViewItem);
var
   txt : TListItemText;
begin
   txt := TListItemText(Item.Objects.FindDrawable('txtDescricao'));
   txt.Width := Self.Width - txt.PlaceOffset.x - 100 ;
end;

procedure TFPrincipal.AddCategoria (listview: TlistView; idcategoria, categoria: string; foto: TStream);
var
   txt : TListItemText;
   img : TListItemImage;
   bmp : TBitmap;
begin
   with listview.Items.Add do
   begin
      TagString := idcategoria;
      //txtDescricao - Feito de uma forma
      txt := TListItemText(Objects.FindDrawable('txtCategoria'));
      txt.Text := categoria;

      //Icone
      img := TListItemImage(Objects.FindDrawable('imgIcone'));

      if foto <> nil then
      begin
         bmp := TBitmap.Create;
         bmp.LoadFromStream(foto);

         img.OwnsBitmap := true;
         img.Bitmap := bmp;
      end;
   end;
end;

procedure TFPrincipal.SetupCategoria(lv: TlistView; Item: TlistViewItem);
var
   txt : TListItemText;
begin
   txt := TListItemText(Item.Objects.FindDrawable('txtCategoria'));
   txt.Width := Self.Width - txt.PlaceOffset.x - 100 ;
end;

//**********************************************************

procedure TFPrincipal.ListarUltLanc;
var
   foto : TStream;
   lanc : TLancamento;
   qry : TFDQuery;
   erro : string;
begin
   try
      lvLancamento.Items.Clear;

      lanc := TLancamento.Create(dm.conn);
      qry := lanc.ListarLancamento(10, erro);//Ajustar depois, marcação.

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

         AddLancamento(FPrincipal.lvLancamento,
                       qry.FieldByName('ID_LANCAMENTO').AsString,
                       qry.FieldByName('DESCRICAO').AsString,
                       qry.FieldByName('DESCRICAO_CATEGORIA').AsString,
                       qry.FieldByName('DATA').AsDateTime,
                       qry.FieldByName('VALOR').AsFloat,
                       foto);
         qry.Next;

         foto.DisposeOf;
      end;

   finally
      lanc.DisposeOf;
   end;

   foto := TMemoryStream.Create;
   imgCategoria.Bitmap.SaveToStream(foto);
   foto.Position := 0;

   foto.DisposeOf;
end;

procedure TFPrincipal.FormShow(Sender: TObject);
begin
   ListarUltLanc;
end;

procedure TFPrincipal.imgFechaMenuClick(Sender: TObject);
begin
   faMenu.Start;
end;

procedure TFPrincipal.btnAddLancClick(Sender: TObject);
begin
   if not Assigned(FFLancamentoNovo) then
      Application.CreateForm(TFFLancamentoNovo, FFLancamentoNovo);

   FFLancamentoNovo.modo := 'I';
   FFLancamentoNovo.idlanc := 0;
   FFLancamentoNovo.ShowModal(procedure(ModalResult: TModalResult)
      begin
         ListarUltLanc;
      end);
end;

procedure TFPrincipal.imgMenuClick(Sender: TObject);
begin
   faMenu.Start;
end;

procedure TFPrincipal.lblMenuCategoriaClick(Sender: TObject);
begin
   faMenu.Start;

   if not Assigned(FFCategoria) then
      Application.CreateForm(TFFCategoria, FFCategoria);

   FFCategoria.Show;
end;

procedure TFPrincipal.lblVerTodosClick(Sender: TObject);
begin
   if not Assigned(FFLancamentos) then
      Application.CreateForm(TFFLancamentos, FFLancamentos);
   FFLancamentos.Show;
end;

procedure TFPrincipal.EditarLancamento(idLancamento: String);
begin

end;

procedure TFPrincipal.lvLancamentoItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
   if not Assigned(FFLancamentoNovo) then
      Application.CreateForm(TFFLancamentoNovo, FFLancamentoNovo);

   FFLancamentoNovo.modo := 'A';
   FFLancamentoNovo.idlanc := AItem.TagString.ToInteger;

   FFLancamentoNovo.ShowModal(procedure(ModalResult: TmodalResult)
      begin
         ListarUltLanc;
      end);
end;

procedure TFPrincipal.lvLancamentoUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
   SetupLancamento(lvLancamento, AItem);
end;

end.
