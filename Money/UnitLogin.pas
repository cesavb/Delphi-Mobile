unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit, FMX.TabControl,
  System.Actions, FMX.ActnList, u99Permissions, FMX.MediaLibrary.Actions,

  {$IFDEF ANDROID}
     FMX.VirtualKeyboard, FMX.Platform,
  {$ENDIF}

  FMX.StdActns, FMX.Gestures;

type
  TFLogin = class(TForm)
    Login: TLayout;
    Logo: TImage;
    rrLogin: TRoundRect;
    lytLogin: TLayout;
    lytSenha: TLayout;
    rrSenha: TRoundRect;
    lytBtnLogin: TLayout;
    rctLogin: TRoundRect;
    edtSenha: TEdit;
    lblAcessar: TLabel;
    StyleBook1: TStyleBook;
    edtLogin: TEdit;
    TabControl1: TTabControl;
    TabLogin: TTabItem;
    TabConta: TTabItem;
    Layout1: TLayout;
    Image1: TImage;
    Layout2: TLayout;
    RoundRect2: TRoundRect;
    Edit1: TEdit;
    Layout3: TLayout;
    RoundRect3: TRoundRect;
    Edit2: TEdit;
    Layout4: TLayout;
    btnProximo: TRoundRect;
    lblProximo: TLabel;
    Layout5: TLayout;
    RoundRect5: TRoundRect;
    edtNome: TEdit;
    TabFoto: TTabItem;
    Layout6: TLayout;
    imgEdtFoto: TCircle;
    Layout7: TLayout;
    btnCria: TRoundRect;
    btnCriar: TLabel;
    TabEscolherFoto: TTabItem;
    Layout8: TLayout;
    Layout9: TLayout;
    lblCriar: TLabel;
    Label8: TLabel;
    Rectangle1: TRectangle;
    Layout10: TLayout;
    Layout11: TLayout;
    Label1: TLabel;
    lblLogin: TLabel;
    Rectangle2: TRectangle;
    Layout16: TLayout;
    Label7: TLabel;
    imgCamera: TImage;
    imgLibrary: TImage;
    Layout19: TLayout;
    Layout20: TLayout;
    btnVoltaFoto: TImage;
    Layout17: TLayout;
    Layout18: TLayout;
    btnVoltaConta: TImage;
    Layout14: TLayout;
    Layout15: TLayout;
    btnVoltaLogin: TImage;
    ActionList1: TActionList;
    actLogin: TChangeTabAction;
    actConta: TChangeTabAction;
    actFoto: TChangeTabAction;
    actEscolherFoto: TChangeTabAction;
    actLibrary: TTakePhotoFromLibraryAction;
    actCamera: TTakePhotoFromCameraAction;
    GestureManager1: TGestureManager;
    procedure lblCriarClick(Sender: TObject);
    procedure lblProximoClick(Sender: TObject);
    procedure imgEdtFotoClick(Sender: TObject);
    procedure btnVoltaLoginClick(Sender: TObject);
    procedure btnVoltaContaClick(Sender: TObject);
    procedure btnVoltaFotoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure imgCameraClick(Sender: TObject);
    procedure imgLibraryClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actLibraryDidFinishTaking(Image: TBitmap);
    procedure actCameraDidFinishTaking(Image: TBitmap);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure rctLoginClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnProximoClick(Sender: TObject);
    procedure btnCriaClick(Sender: TObject);
    procedure lblLoginClick(Sender: TObject);
    procedure lblAcessarClick(Sender: TObject);
    procedure TabControl1Gesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
  private
    { Private declarations }
    permissao: T99Permissions;
    procedure TrataErroPermissao(Sender: TObject);
  public
    { Public declarations }
  end;

var
  FLogin: TFLogin;

implementation

{$R *.fmx}

uses UnitPrincipal;

procedure TFLogin.TabControl1Gesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
   //Movimento para a esquerda
   if EventInfo.GestureID = sgiLeft then
   begin
      if TabControl1.ActiveTab = TabLogin then
         TabControl1.GotoVisibleTab(1)
      else if TabControl1.ActiveTab = TabConta then
         TabControl1.GotoVisibleTab(2)
   end;
   //Movimento para a direita
   if EventInfo.GestureID = sgiRight then
   begin
      if TabControl1.ActiveTab = TabConta then
         TabControl1.GotoVisibleTab(0)
      else if TabControl1.ActiveTab = TabFoto then
         TabControl1.GotoVisibleTab(1)
   end;

end;

procedure TFLogin.TrataErroPermissao(Sender: TObject);
begin
  Showmessage('Você não possui permissão de acesso para utilizar esse recurso!');
end;

procedure TFLogin.actCameraDidFinishTaking(Image: TBitmap);
begin
  imgEdtFoto.Fill.Bitmap.Bitmap := Image;
  actFoto.Execute;
end;

procedure TFLogin.actLibraryDidFinishTaking(Image: TBitmap);
begin
  imgEdtFoto.Fill.Bitmap.Bitmap := Image;
  actFoto.Execute;
end;

procedure TFLogin.btnVoltaContaClick(Sender: TObject);
begin
  actConta.Execute;
end;

procedure TFLogin.btnVoltaFotoClick(Sender: TObject);
begin
  actFoto.Execute;
end;

procedure TFLogin.btnVoltaLoginClick(Sender: TObject);
begin
  actLogin.Execute;
end;

procedure TFLogin.imgEdtFotoClick(Sender: TObject);
begin
  actEscolherFoto.Execute;
end;

procedure TFLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Action := TCloseAction.caFree;
   FLogin := nil;
end;

procedure TFLogin.FormCreate(Sender: TObject);
begin
  permissao := T99Permissions.Create;
end;

procedure TFLogin.FormDestroy(Sender: TObject);
begin
  permissao.DisposeOf;
end;

procedure TFLogin.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
{$IFDEF ANDROID}
var
   FService : IFMXVirtualKeyboardService;
{$ENDIF}
begin
   {$IFDEF ANDROID}
   if (Key = vkHardwareBack) then begin
      TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(FService));
      if (FService <> nil) and (TVirtualKeyboardState.Visible in FService.VirtualKeyboardState) then begin
         // Botão back pressionado e teclado visível...
         // Apenas fecha o teclado
      end else begin
         // Botão back pressionado e teclado não visível...
         if TabControl1.ActiveTab = TabConta then begin
            key := 0;
            ActLogin.Execute;
         end;

         if TabControl1.ActiveTab = TabFoto then begin
            key := 0;
            ActConta.Execute;
         end;

         if TabControl1.ActiveTab = TabEscolherFoto then begin
            key := 0;
            ActFoto.Execute;
         end;

      end;
   end;
   {$ENDIF}
end;
procedure TFLogin.FormShow(Sender: TObject);
begin
  TabControl1.ActiveTab := TabLogin;
end;

procedure TFLogin.imgCameraClick(Sender: TObject);
begin
  permissao.Camera(actCamera, TrataErroPermissao);
end;

procedure TFLogin.imgLibraryClick(Sender: TObject);
begin
  permissao.PhotoLibrary(actLibrary, TrataErroPermissao);
end;

procedure TFLogin.lblLoginClick(Sender: TObject);
begin
   actLogin.Execute;
end;

procedure TFLogin.lblAcessarClick(Sender: TObject);
begin
  if not Assigned(FPrincipal) then
      Application.CreateForm(TFPrincipal, FPrincipal);

   Application.MainForm := FPrincipal;
   FPrincipal.Show;
   FLogin.Close;
end;

procedure TFLogin.lblCriarClick(Sender: TObject);
begin
  actConta.Execute;
end;

procedure TFLogin.lblProximoClick(Sender: TObject);
begin
  actFoto.Execute;
end;

procedure TFLogin.btnProximoClick(Sender: TObject);
begin
   actFoto.Execute;
end;

procedure TFLogin.rctLoginClick(Sender: TObject);
begin
   if not Assigned(FPrincipal) then
      Application.CreateForm(TFPrincipal, FPrincipal);

   Application.MainForm := FPrincipal;
   FPrincipal.Show;
   FLogin.Close;
end;

procedure TFLogin.btnCriaClick(Sender: TObject);
begin
   if not Assigned(FPrincipal) then
      Application.CreateForm(TFPrincipal, FPrincipal);

   Application.MainForm := FPrincipal;
   FPrincipal.Show;
   FLogin.Close;
end;

end.
