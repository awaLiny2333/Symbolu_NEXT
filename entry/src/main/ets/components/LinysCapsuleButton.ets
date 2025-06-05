import { copy } from '../utils/clipboard_tools';

@Component
struct LinysCapsuleButton {
  @Prop text: ResourceStr = "   ";
  @Prop fontSize: number = 22;
  @Prop allowCopy: boolean = true;
  @Prop copyFormat: string = '%k';

  aboutToAppear(): void {
    // Preprocess of text
    this.text = this.text == "" ? "¯\\_(ツ)_/¯" : this.text;
  }

  build() {
    Button(this.text)
      .type(ButtonType.Capsule)
      .backgroundColor($r("app.color.supplementary"))
      .fontColor($r("app.color.accent"))
      .fontSize(this.fontSize)
      .fontWeight(FontWeight.Medium)
      .clickEffect({ level: ClickEffectLevel.LIGHT })
      .onClick(() => {
        if (this.allowCopy && typeof this.text == "string") {
          copy(this.copyFormat.replaceAll('%k', this.text) as string);
        }
      })
  }
}

export default LinysCapsuleButton;