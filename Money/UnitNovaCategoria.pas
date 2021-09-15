unit UnitNovaCategoria;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, UnitPrincipal,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit,
  FMX.ListBox, cCategoria, UnitDM,FireDAC.comp.Client, FireDAC.DApt,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdFinger,
  FMX.DialogService;

type
  TFFNovaCat = class(TForm)
    Layout5: TLayout;
    lblTitulo: TLabel;
    btnVoltarConta: TImage;
    imgSalve: TImage;
    Layout4: TLayout;
    Label1: TLabel;
    edtDescricao: TEdit;
    Line1: TLine;
    Layout1: TLayout;
    Label2: TLabel;
    lbIcone: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    ListBoxItem6: TListBoxItem;
    ListBoxItem7: TListBoxItem;
    ListBoxItem8: TListBoxItem;
    ListBoxItem9: TListBoxItem;
    ListBoxItem10: TListBoxItem;
    ListBoxItem11: TListBoxItem;
    ListBoxItem12: TListBoxItem;
    ListBoxItem13: TListBoxItem;
    ListBoxItem14: TListBoxItem;
    ListBoxItem15: TListBoxItem;
    ListBoxItem16: TListBoxItem;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    Image13: TImage;
    Image14: TImage;
    Image15: TImage;
    Image16: TImage;
    Image17: TImage;
    imgSelecao: TImage;
    btnDelete: TRectangle;
    imgDelete: TImage;
    procedure FormResize(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure btnVoltarContaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure imgSalveClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure imgDeleteClick(Sender: TObject);
  private
    iconeClick: TBitmap;
    procedure SelecionaIcone(img: TImage);
    { Private declarations }
  public
    { Public declarations }
    modo: string; // I(Inclusão || A(Alteração)
    idCat: integer;
    indiceSelec: integer;
  end;

var
  FFNovaCat: TFFNovaCat;

implementation

{$R *.fmx}

uses UnitCategorias;

procedure TFFNovaCat.SelecionaIcone(img: TImage);
begin
   //Salvar o icone que foi clicado
   iconeClick := img.Bitmap; //Salva o icone selecionado
   indiceSelec := TListBoxItem(img.Parent).Index;//Devolve o index da imagem

   imgSelecao.Parent := img.Parent;
end;

procedure TFFNovaCat.imgDeleteClick(Sender: TObject);
var
   cat: TCategoria;
   erro: string;
begin
   TDialogService.MessageDialog('Confirma a exclusão da categoria?',
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
        cat := Tcategoria.Create(dm.conn);
        try
           cat.ID_CATEGORIA := idcat;
           if cat.Excluir(erro) = False then
           begin
              ShowMessage(erro);
              exit;
           end;
           FFCategoria.ListarCategorias;
           close;
        finally
           cat.DisposeOf;
        end;
     end;
   end);
end;
procedure TFFNovaCat.imgSalveClick(Sender: TObject);
var
   cat : TCategoria;
   erro: string;
begin
   try
      cat := TCategoria.Create(dm.conn);
      cat.DESCRICAO := edtDescricao.Text;
      cat.ICONE := iconeClick;
      cat.INDICE_ICONE := indiceSelec;

      if modo = 'I' then
         cat.Inserir(erro)
      else
      begin
         cat.ID_CATEGORIA := idCat;
         cat.Alterar(erro);
      end;

      if erro <> '' then
      begin
         ShowMessage(erro);
         exit;
      end;

      FFCategoria.ListarCategorias;
      close;
   finally
      cat.DisposeOf;
   end;
end;

procedure TFFNovaCat.Image2Click(Sender: TObject);
begin
   SelecionaIcone(TImage(Sender));
end;

procedure TFFNovaCat.btnDeleteClick(Sender: TObject);
var
   cat: TCategoria;
   erro: string;
begin
   TDialogService.MessageDialog('Confirma a exclusão da categoria?',
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
        cat := Tcategoria.Create(dm.conn);
        try
           cat.ID_CATEGORIA := idcat;
           if cat.Excluir(erro) = False then
           begin
              ShowMessage(erro);
              exit;
           end;
           FFCategoria.ListarCategorias;
           close;
        finally
           cat.DisposeOf;
        end;
     end;
   end);
end;

procedure TFFNovaCat.btnVoltarContaClick(Sender: TObject);
begin
   close;
end;

procedure TFFNovaCat.FormResize(Sender: TObject);
begin
   lbIcone.Columns := Trunc(lbIcone.Width / 80);
end;

procedure TFFNovaCat.FormShow(Sender: TObject);
var
   cat : TCategoria;
   qry : TFDQuery;
   erro: string;
   //icone: TStream;
   item : TListBoxItem;
   img : TImage;
begin

   if modo ='I' then
   begin
      edtDescricao.Text := ''; //Limpa o Edit
      SelecionaIcone(Image2); //Por padrão a primeira imagem é selecionada
      btnDelete.Visible := false; //Escondendo o botão de excluir
   end
   else
   begin
      try
         btnDelete.Visible := true; //Mostrando o botão de excluir

         cat := TCategoria.Create(dm.conn);
         cat.ID_CATEGORIA := idCat;

         qry := cat.ListarCategoria(erro);

         edtDescricao.Text := qry.FieldByName('DESCRICAO').AsString;

         //ICONE
         item := lbIcone.ItemByIndex(qry.FieldByName('INDICE_ICONE').AsInteger); //Buscar o item da ListBox
         imgSelecao.Parent := item;

         img := FFCategoria.FindComponent('Image' + (item.Index + 1).tostring) as TImage;
         SelecionaIcone(img);
      finally
         qry.DisposeOf;
         cat.DisposeOf;
      end;
   end
end;

end.
