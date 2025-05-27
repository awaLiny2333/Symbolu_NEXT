import { copy } from "../utils/clipboard_tools";

@Component
struct LinysCapsuleButton {
  @Prop text: ResourceStr = "   ";
  @Prop fontSize: number = 22;
  @Prop allowCopy: boolean = true;

  aboutToAppear(): void {
    // Preprocess of text
    this.text = this.text == "" ? "¯\\_(ツ)_/¯" : this.text;
  }

  build() {
    Button(this.text)
      .type(ButtonType.Capsule)
      .backgroundColor($r('app.color.block_color'))
      .fontColor($r('app.color.font_color_title'))
      .fontSize(this.fontSize)
      .fontWeight(FontWeight.Medium)
      .backgroundColor($r('app.color.block_color'))
      .clickEffect({ level: ClickEffectLevel.LIGHT })
      .onClick(() => {
        if (this.allowCopy && typeof this.text == "string") {
          copy(this.text as string);
        }
      })
  }
}

export default LinysCapsuleButton;