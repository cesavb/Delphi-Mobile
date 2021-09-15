unit UnitCategorias;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  UnitNovaCategoria, cCategoria, FireDAC.comp.Client, FireDAC.DApt, UnitDM, Data.DB;

type
  TFFCategoria = class(TForm)
    Layout17: TLayout;
    Label1: TLabel;
    btnVoltarConta: TImage;
    Rectangle5: TRectangle;
    btnAdd: TImage;
    lblQtdCat: TLabel;
    lvCategoria: TListView;
    procedure btnVoltarContaClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure lvCategoriaUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure btnAddClick(Sender: TObject);
    procedure lvCategoriaItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    procedure CadCategoria(idCat: string);
    { Private declarations }
  public
    { Public declarations }
    procedure ListarCategorias;
  end;

var
  FFCategoria: TFFCategoria;

implementation

{$R *.fmx}

uses UnitPrincipal;

procedure TFFCategoria.CadCategoria(idCat: string);
var
   cat : TCategoria;
   qry : TFDQuery;
   erro: string;
   icone: TStream;
begin
   if not Assigned(FFNovaCat) then
      Application.CreateForm(TFFNovaCat, FFNovaCat);
   //INCLUSÃO
   if idCat = '' then
   begin
      FFNovaCat.idCat := 0;
      FFNovaCat.modo :='I';
      FFNovaCat.lblTitulo.Text := 'Nova Categoria'
   end
   else
   // ALTERAÇÃO
   begin
      FFNovaCat.idCat := idCat.tointeger;
      FFNovaCat.modo :='A';
      FFNovaCat.lblTitulo.text := 'Editar Categoria';
   end;

   FFNovaCat.Show;
end;

procedure TFFCategoria.btnAddClick(Sender: TObject);
begin
   CadCategoria('');

end;

procedure TFFCategoria.btnVoltarContaClick(Sender: TObject);
begin
  close;
end;

procedure TFFCategoria.ListarCategorias;
var
   cat : TCategoria;
   qry : TFDQuery;
   erro: string;
   icone: TStream;
begin
   try
      lvCategoria.Items.Clear;

      cat := TCategoria.Create(dm.conn);
      qry := cat.ListarCategoria(erro);

      while not qry.Eof do
      begin
         if qry.FieldByName('ICONE').AsString <> '' then
            icone :=qry.CreateBlobStream(qry.FieldByName('ICONE'), TBlobStreamMode.bmRead)
         else
            icone := nil;


         FPrincipal.AddCategoria(lvCategoria,
                                 qry.FieldByName('ID_CATEGORIA').AsString,
                                 qry.FieldByName('DESCRICAO').AsString,
                                 icone);

         if icone <> nil then
            icone.DisposeOf;

         qry.Next;
      end;

      if (lvCategoria.Items.Count) <= 1 then
         lblQtdCat.Text := lvCategoria.items.Count.ToString + ' categoria'
      else
         lblQtdCat.Text := lvCategoria.items.Count.ToString + ' categorias';

   finally
      qry.DisposeOf;
      cat.DisposeOf;
   end;
end;

procedure TFFCategoria.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  FFCategoria := nil;
end;

procedure TFFCategoria.FormShow(Sender: TObject);
begin
   ListarCategorias;
end;

procedure TFFCategoria.lvCategoriaItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
   CadCategoria(AItem.TagString);
end;

procedure TFFCategoria.lvCategoriaUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
   FPrincipal.SetupCategoria(lvCategoria, AItem);
end;

end.
