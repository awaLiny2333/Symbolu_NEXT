import { animationDefault } from '../data/animationDefault';
import LinysCapsuleButton from './LinysCapsuleButton';

@Component
struct LinysColors {
  // Defaults
  @Prop colorDefault: ResourceColor | undefined = undefined;
  @Prop descDefault: string = 'accent';
  // Data
  @Link colorSelected: ResourceColor | undefined;
  @State descSelected: string = this.descDefault;
  // Environment
  @StorageProp('space') space: number = 10;

  build() {
    Column({ space: this.space }) {
      Scroll() {
        Row({ space: this.space }) {
          colorDot({
            color: $r('sys.color.ohos_id_color_emphasize'),
            desc: 'emphasize',
            colorSelected: this.colorSelected,
            descSelected: this.descSelected,
          })
          colorDot({
            color: $r('sys.color.ohos_id_color_warning'),
            desc: 'warning',
            colorSelected: this.colorSelected,
            descSelected: this.descSelected,
          })
          colorDot({
            color: $r('sys.color.ohos_id_color_alert'),
            desc: 'alert',
            colorSelected: this.colorSelected,
            descSelected: this.descSelected,
          })
          colorDot({
            color: $r('sys.color.ohos_id_color_connected'),
            desc: 'connected',
            colorSelected: this.colorSelected,
            descSelected: this.descSelected,
          })
          colorDot({
            color: $r('sys.color.ohos_id_color_primary'),
            desc: 'primary',
            colorSelected: this.colorSelected,
            descSelected: this.descSelected,
          })
          colorDot({
            color: $r('sys.color.ohos_id_color_secondary'),
            desc: 'secondary',
            colorSelected: this.colorSelected,
            descSelected: this.descSelected,
          })
          colorDot({
            color: $r('sys.color.ohos_id_color_tertiary'),
            desc: 'tertiary',
            colorSelected: this.colorSelected,
            descSelected: this.descSelected,
          })
          colorDot({
            color: $r('sys.color.ohos_id_color_fourth'),
            desc: 'fourth',
            colorSelected: this.colorSelected,
            descSelected: this.descSelected,
          })
        }
      }
      .scrollBar(BarState.Off)
      .scrollable(ScrollDirection.Horizontal)
      .edgeEffect(EdgeEffect.Spring)
      .animation(animationDefault())

      Row({ space: this.space }) {
        SymbolGlyph($r('sys.symbol.arrow_counterclockwise'))
          .borderRadius(20)
          .padding(10)
          .backgroundColor($r("app.color.supplementary"))
          .fontColor([$r("app.color.accent")])
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .clickEffect({ level: ClickEffectLevel.LIGHT })
          .onClick(() => {
            this.descSelected = this.descDefault;
            this.colorSelected = this.colorDefault;
          })
        LinysCapsuleButton({ text: this.descSelected, copyFormat: '$r(\'sys.color.ohos_id_color_%k\')' })
          .animation(animationDefault())
      }
    }
    .alignItems(HorizontalAlign.End)
  }
}

export default LinysColors;

@Component
struct colorDot {
  @Prop color: ResourceColor = Color.Red;
  @State desc: string = 'accent';
  // Data
  @Link colorSelected: ResourceColor;
  @Link descSelected: string;

  build() {
    Row() {
      Text('󰀓')
        .fontSize(20)
        .fontWeight(FontWeight.Bolder)
        .fontColor($r('sys.color.ohos_id_color_background'))
        .visibility(this.desc == this.descSelected ? Visibility.Visible : Visibility.None)
        .animation(animationDefault())
    }
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .width(40)
    .height(40)
    .borderRadius(20)
    .backgroundColor(this.color)
    .clickEffect({ level: ClickEffectLevel.LIGHT })
    .onClick(() => {
      this.colorSelected = this.color;
      this.descSelected = this.desc;
    })
  }
}