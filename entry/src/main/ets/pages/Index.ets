import LinysCapsuleButton from '../components/LinysCapsuleButton';
import LinysSymbolDisplay from '../components/LinysSymbolDisplay';
import { allSymbols } from '../data/allSymbols';
import { animationDefault } from '../data/animationDefault';
import { linysSymbol } from '../objects/linysSymbol';
import LinysSymbolDataSource from '../objects/SymbolDataSource';
import { ItemRestriction, SegmentButton, SegmentButtonOptions, SegmentButtonTextItem } from '@kit.ArkUI';
import LinysColors from '../components/LinysColors';

@Entry
@Component
struct Index {
  // Environment
  @StorageLink('tablet_mode') tablet_mode: boolean = false;
  @StorageLink('screen_width') screen_width: number = 0;
  @StorageLink('screen_height') screen_height: number = 0;
  @StorageLink('screen_ratio') screen_ratio: number = 0;
  @StorageLink('space') space: number = 10;
  // UI
  @State inputText: string = "";
  @State symbolTest: Resource = $r('sys.symbol.camera_slash_fill');
  @State selected: linysSymbol = allSymbols[0];
  @State waterFlowWidth: number = 0;
  @State scrollInfoHeight: number = 0;
  @State showMore: boolean = false;
  // Data
  data: LinysSymbolDataSource = new LinysSymbolDataSource(allSymbols);
  // Symbols
  @StorageLink('symbolFontWeight') symbolFontWeight: number = 400;
  @StorageLink('symbolBackgroundColor') colorBackground: ResourceColor | undefined = undefined;

  build() {
    RelativeContainer() {
      WaterFlow() {
        LazyForEach(this.data, (s: linysSymbol) => {
          LinysSymbolDisplay({
            symbol: s,
            selected: this.selected
          })
        }, (s: linysSymbol) => {
          return s.unicode;
        })
      } // Symbols
      .id('symbols')
      .columnsTemplate(this.columnsTemplate())
      .backgroundColor(this.colorBackground)
      .padding(this.space)
      .columnsGap(this.space)
      .rowsGap(this.space)
      .edgeEffect(EdgeEffect.Spring)
      .borderRadius(20)
      .alignRules(this.tablet_mode ?
        {
          top: { anchor: '__container__', align: VerticalAlign.Top },
          bottom: { anchor: 'info', align: VerticalAlign.Top },
          left: { anchor: '__container__', align: HorizontalAlign.Start },
          right: { anchor: 'operations', align: HorizontalAlign.Start },
        } :
        {
          top: { anchor: '__container__', align: VerticalAlign.Top },
          bottom: { anchor: 'operations', align: VerticalAlign.Top },
        })
      .animation(animationDefault())
      .onAreaChange((_o, n) => {
        this.waterFlowWidth = n.width as number - this.space * 2;
      })

      Operations({ showMore: this.showMore })
        .id('operations')
        .width(this.tablet_mode ? (this.showMore ? 300 : 50) : '100%')
        .height(this.tablet_mode ? undefined : (this.showMore ? '60%' : 30))
        .animation(animationDefault())
        .alignRules(this.tablet_mode ?
          {
            top: { anchor: '__container__', align: VerticalAlign.Top },
            bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
            right: { anchor: '__container__', align: HorizontalAlign.End },
          } :
          {
            bottom: { anchor: 'info', align: VerticalAlign.Top }
          })

      InfoCopyBar({ selected: this.selected })
        .id('info')
        .padding({ top: this.space })
        .alignRules(this.tablet_mode ?
          {
            bottom: { anchor: 'search', align: VerticalAlign.Top },
            left: { anchor: '__container__', align: HorizontalAlign.Start },
            right: { anchor: 'operations', align: HorizontalAlign.Start },
          } :
          {
            bottom: { anchor: 'search', align: VerticalAlign.Top }
          })

      Row({ space: this.space }) {
        TextInput({ text: this.inputText })// Search Blank
          .layoutWeight(1)
          .onChange((newText) => {
            this.inputText = newText;
          })
          .onSubmit(() => {
            this.searchFor(this.inputText);
          })
        SymbolGlyph($r('sys.symbol.arrow_counterclockwise'))// Reset Button
          .fontColor([$r("app.color.accent")])
          .fontSize(36)
          .onClick(() => {
            this.inputText = '';
            this.searchFor('');
          })
      } // Search
      .id('search')
      .padding({ top: this.space })
      .alignRules(this.tablet_mode ?
        {
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
          left: { anchor: '__container__', align: HorizontalAlign.Start },
          right: { anchor: 'operations', align: HorizontalAlign.Start },
        } :
        {
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
        })
    }
    .animation(animationDefault())
    .padding({
      left: 15,
      right: 15,
      top: 5,
      bottom: 15
    })
    .height('100%')
    .width('100%')
    .onAreaChange((o, n) => {
      this.on_main_area_change(o, n);
    })
  }

  searchFor(key: string) {
    console.log('[Woof]Searching for key: ' + key);
    let searchResult: linysSymbol[] = [];
    for (let index = 0; index < allSymbols.length; index++) {
      const element = allSymbols[index];
      if (element.name.toUpperCase().includes(key.toUpperCase())) {
        searchResult.push(element);
      }
    }
    this.data.setData(searchResult);
  }

  on_main_area_change(_old: Area, n: Area) {
    this.screen_width = n.width as number;
    this.screen_height = n.height as number;
    this.tablet_mode = this.screen_width > 500;
    this.screen_ratio = this.screen_width / this.screen_height;
  }

  columnsTemplate() {
    return "1fr ".repeat(Math.floor(this.waterFlowWidth / 55));
  }
}

@Component
struct InfoCopyBar {
  // Environment
  @StorageProp('space') space: number = 10;
  // UI
  @Prop selected: linysSymbol;

  build() {
    Scroll() {
      Row({ space: this.space }) {
        LinysCapsuleButton({ text: "No. " + this.selected.id.toString() })
        LinysCapsuleButton({ text: " " + this.selected.char + " ", fontSize: 26 })
        LinysCapsuleButton({ text: this.selected.unicode })
        LinysCapsuleButton({ text: this.selected.name })
      }
    } // Info and Copy buttons
    .borderRadius(20)
    .align(Alignment.TopStart)
    .scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.Spring)
  }
}

@Component
struct Operations {
  // Environment
  @StorageLink('tablet_mode') tablet_mode: boolean = false;
  @StorageProp('space') space: number = 10;
  // UI
  @Link showMore: boolean;
  @State colorOptions: SegmentButtonOptions = SegmentButtonOptions.tab({
    buttons: [{ text: '󰦜' }, { text: '󰘱' }, { text: '󰘔' },] as ItemRestriction<SegmentButtonTextItem>,
    fontColor: $r('app.color.accent'),
    selectedFontColor: $r('app.color.supplementary'),
    selectedBackgroundColor: $r('app.color.accent'),
    fontSize: 24,
    selectedFontSize: 24,
  })
  @State @Watch('onSymbolRenderingStrategySelect') symbolRenderingStrategySelectedIndices: number[] = [1];
  // Color
  @State @Watch('onColorChange') colorPrimary: ResourceColor = $r("app.color.accent");
  @State @Watch('onColorChange') colorSecondary: ResourceColor = $r("sys.color.ohos_id_color_connected");
  @StorageLink('symbolBackgroundColor') colorBackground: ResourceColor | undefined = undefined;
  // Symbol
  @StorageLink('symbolRenderingStrategy') symbolRenderingStrategy: number = 1;
  @StorageLink('symbolFontWeight') symbolFontWeight: number = 200;
  @StorageLink('symbolColors') symbolColors: ResourceColor[] = [this.colorPrimary, this.colorSecondary];

  build() {
    Column({ space: this.space }) {
      Text(this.tablet_mode ? (this.showMore ? '󰃙' : '󰃚') : (this.showMore ? '󰃛' : '󰃘'))// Hide / Show button
        .fontColor($r("app.color.accent"))
        .textAlign(this.tablet_mode ? TextAlign.Start : TextAlign.Center)
        .fontSize(40)
        .clickEffect({ level: ClickEffectLevel.LIGHT })
        .width('100%')
        .onClick(() => {
          this.showMore = !this.showMore;
        })
        .margin(this.tablet_mode ? { left: this.space } : {})

      Scroll() {
        Column({ space: this.space }) {
          Row() {
            Text('󰁙')
              .fontSize(30)
              .fontColor($r("app.color.accent"))
            Slider({
              min: 100,
              max: 900,
              value: this.symbolFontWeight,
              style: SliderStyle.InSet,
              step: 100
            })
              .layoutWeight(1)
              .selectedColor($r('app.color.accent'))
              .blockColor($r('app.color.supplementary'))
              .onChange((value: number) => {
                // console.log(value.toString())
                this.symbolFontWeight = value;
              })
          } // FontWeight slider
          LinysCapsuleButton({
            text: this.fontWeightIndicator(),
            copyFormat: this.fontWeightIndicator().includes('0') ? '.fontWeight(%k)' : '.fontWeight(FontWeight.%k)'
          })
          Row() // For spacing
          SegmentButton({ options: this.colorOptions, selectedIndexes: this.symbolRenderingStrategySelectedIndices })
          LinysCapsuleButton({ text: this.symbolRenderingStrategyIndicator(),copyFormat:'.renderingStrategy(SymbolRenderingStrategy.%k)' })
          LinysColors({
            colorSelected: this.colorPrimary,
            colorDefault: $r('app.color.accent'),
            descDefault: 'accent'
          })
          LinysColors({
            colorSelected: this.colorSecondary,
            colorDefault: $r('sys.color.ohos_id_color_connected'),
            descDefault: 'connected'
          })
          LinysColors({
            colorSelected: this.colorBackground,
            colorDefault: undefined,
            descDefault: 'background',
          })
        }
        .alignItems(HorizontalAlign.End)
        .visibility(this.showMore ? Visibility.Visible : Visibility.Hidden)
        .animation(animationDefault())
      } // Body
      .borderRadius(20)
      .align(Alignment.Top)
      .width('100%')
      .layoutWeight(1)
      .scrollable(ScrollDirection.Vertical)
      .edgeEffect(EdgeEffect.Spring)

    } // Operations
    .padding(this.tablet_mode ? { left: this.space } : {})
  }

  fontWeightIndicator() {
    let extra: string | undefined = undefined;
    switch (this.symbolFontWeight) {
      case 100:
        extra = 'Lighter';
        break;
      case 400:
        extra = 'Regular';
        break;
      case 500:
        extra = 'Medium';
        break;
      case 700:
        extra = 'Bold';
        break;
      case 900:
        extra = 'Bolder';
        break;
    }
    return extra || this.symbolFontWeight.toString();
  }

  onSymbolRenderingStrategySelect() {
    this.symbolRenderingStrategy = this.symbolRenderingStrategySelectedIndices[0];
  }

  symbolRenderingStrategyIndicator() {
    let extra: string = 'SINGLE';
    switch (this.symbolRenderingStrategy) {
      case 0:
        extra = 'SINGLE';
        break;
      case 1:
        extra = 'MULTIPLE_COLOR';
        break;
      case 2:
        extra = 'MULTIPLE_OPACITY';
        break;
    }
    return extra;
  }

  onColorChange() {
    this.symbolColors = [this.colorPrimary, this.colorSecondary];
  }
}