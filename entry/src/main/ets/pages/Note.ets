import router from '@ohos.router'

@Entry
@Component
struct Note {
  @State fontColor: string = '#182431'
  @State selectedFontColor: string = '#007DFF'
  @State currentIndex: number = 0
  private controller: TabsController = new TabsController()
  private show_bills = [`TabBar的宽度值。

默认值：

未设置带样式的TabBar且vertical属性为false时，默认值为Tabs的宽度。

未设置带样式的TabBar且vertical属性为true时，默认值为56vp。

设置SubTabbarStyle样式且vertical属性为false时，默认值为Tabs的宽度。`, `TabBar的宽度值。

默认值：

未设置带样式的TabBar且vertical属性为false时，默认值为Tabs的宽度。

未设置带样式的TabBar且vertical属性为true时，默认值为56vp。

设置SubTabbarStyle样式且vertical属性为false时，默认值为Tabs的宽度。`, `TabBar的宽度值。

默认值：

未设置带样式的TabBar且vertical属性为false时，默认值为Tabs的宽度。

未设置带样式的TabBar且vertical属性为true时，默认值为56vp。

设置SubTabbarStyle样式且vertical属性为false时，默认值为Tabs的宽度。`, `TabBar的宽度值。

默认值：

未设置带样式的TabBar且vertical属性为false时，默认值为Tabs的宽度。

未设置带样式的TabBar且vertical属性为true时，默认值为56vp。

设置SubTabbarStyle样式且vertical属性为false时，默认值为Tabs的宽度。`, `TabBar的宽度值。

默认值：

未设置带样式的TabBar且vertical属性为false时，默认值为Tabs的宽度。

未设置带样式的TabBar且vertical属性为true时，默认值为56vp。

设置SubTabbarStyle样式且vertical属性为false时，默认值为Tabs的宽度。`, `TabBar的宽度值。

默认值：

未设置带样式的TabBar且vertical属性为false时，默认值为Tabs的宽度。

未设置带样式的TabBar且vertical属性为true时，默认值为56vp。

设置SubTabbarStyle样式且vertical属性为false时，默认值为Tabs的宽度。`]
  private bills = [`提供勾选框样式、状态按钮样式及开关样式`,`提供勾选框样式、状态按钮样式及开关样式`,`提供勾选框样式、状态按钮样式及开关样式`,`提供勾选框样式、状态按钮样式及开关样式`,`提供勾选框样式、状态按钮样式及开关样式`,`提供勾选框样式、状态按钮样式及开关样式`]
  @State finish : Array<boolean>= [false,false,false,false,false,false]
  //当前页面
  @State position_x: number | string = '78%'
  @State position_y: number | string = '60%'
  @State vis: Visibility = Visibility.Visible
  private xxx: any = 0
  private xx1: any = 0
  //列表项删除的修饰
  @Builder deletes(item) {
    Button() {
      Text("删除").fontSize(20)
    }
    .width('30%')
    .height(100)
    .onClick(() => {
      this.show_bills.splice(item, 1)
    })
    .stateEffect(true)
    .type(ButtonType.Normal)
    .borderRadius(10)
    .flexShrink(1)
  }

  @Builder TabBuilder(index: number, name: string) {
    Column() {
      Text(name)
        .fontColor(this.currentIndex === index ? this.selectedFontColor : this.fontColor)
        .fontSize(16)
        .fontWeight(this.currentIndex === index ? 500 : 400)
        .lineHeight(22)
        .margin({ top: 17, bottom: 7 })
      Divider()
        .strokeWidth(2)
        .color('#007DFF')
        .opacity(this.currentIndex === index ? 1 : 0)
    }.width('100%')
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.back'))
          .width(70)
          .height(35)
          .margin({ left: 10, top: 5 })
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            router.back()
          })
      }.width('100%').onAreaChange((_s, s) => {
        this.xxx = s.height
      })

      Stack() {
        Tabs({ controller: this.controller }) {
          TabContent() {
            List({ space: 5, initialIndex: 0 }) {
              ForEach(this.show_bills, (item, index) => {
                ListItem() {
                  Column() {
                    Text(`10/14`)
                      .height(20)
                      .margin({ top: 10, left: 10 })
                      .width('100%')
                      .fontSize(14)
                      .fontWeight(310)
                      .fontColor(Color.Grey)
                    Text(item.toString()).fontSize(18).height(100).margin({ left: 10, top: 20 })
                  }
                  .height(160)
                  .width('90%')
                  .borderRadius(10)
                  .backgroundColor(Color.White)
                  .opacity(0.9)
                }.swipeAction({ end: this.deletes((index)) }).align(Alignment.Center).width('100%').onClick(() => {
                  router.pushUrl({
                    url: 'pages/NoteBook',
                    params: {
                      index: index,
                      add: false
                    }
                  }, router.RouterMode.Single)
                })
              })
            }.width('100%').height('100%').edgeEffect(EdgeEffect.Fade)

          }.tabBar(this.TabBuilder(0, '笔记'))

          TabContent() {
            Column() {
              List({ space: 5, initialIndex: 0 }) {
                ForEach(this.bills, (item, index) => {
                  ListItem() {
                    Row() {
                      Toggle({ type: ToggleType.Checkbox, isOn: this.finish[index] })
                        .size({ width: 20, height: 20 })
                        .selectedColor(Color.Grey)
                        .onChange((isOn: boolean) => {
                          animateTo({ duration: 400 }, () => {
                            this.finish[index] = true
                          })
                        })
                      Text(item.toString())
                        .fontSize(16)
                        .margin({ left: 10, top: 20, bottom: 10 })
                        .width('80%')
                        .decoration({
                          type: this.finish[index] ? TextDecorationType.LineThrough : TextDecorationType.None
                        })
                        .fontColor(this.finish[index] ? Color.Grey : Color.Black)
                    }
                    .width('90%')
                    .borderRadius(10)
                    .backgroundColor(Color.White)
                    .opacity(0.9)
                  }.swipeAction({ end: this.deletes((index)) }).align(Alignment.Center).width('100%').onClick(() => {
                  }).visibility(!this.finish[index] ? Visibility.Visible:Visibility.None).transition({scale:{x:0.5,y:0.5},opacity:0.5})
                })
              }.width('100%').edgeEffect(EdgeEffect.Fade).height(this.finish.indexOf(true) == -1 ? '100%' : '50%')
              Row(){
              Text('已完成的').fontSize(14).fontColor(Color.Grey).margin({left:19})
              }.width('100%')
              List({ space: 5, initialIndex: 0 }) {
                ForEach(this.bills, (item, index) => {
                  ListItem() {
                    Row() {
                      Toggle({ type: ToggleType.Checkbox, isOn: this.finish[index] })
                        .size({ width: 20, height: 20 })
                        .selectedColor(Color.Grey)
                        .onChange((isOn: boolean) => {
                          animateTo({ duration: 400 }, () => {
                            this.finish[index] = false
                          })

                          console.info('Component status:' + isOn)
                        })
                      Text(item.toString())
                        .fontSize(16)
                        .margin({ left: 10, top: 20, bottom: 10 })
                        .width('80%')
                        .decoration({
                          type: this.finish[index] ? TextDecorationType.LineThrough : TextDecorationType.None
                        })
                        .fontColor(this.finish[index] ? Color.Grey : Color.Black)
                    }
                    .width('90%')
                    .borderRadius(10)
                    .backgroundColor(Color.White)
                    .opacity(0.9)
                  }.swipeAction({ end: this.deletes((index)) }).align(Alignment.Center).width('100%').onClick(() => {
                  }).visibility(this.finish[index] ? Visibility.Visible:Visibility.None).transition({scale:{x:0.5,y:0.5},opacity:0.5})
                })
              }.width('100%').edgeEffect(EdgeEffect.Fade).visibility(this.finish.indexOf(true) != -1 ? Visibility.Visible : Visibility.None).height('50%')
            }
          }.tabBar(this.TabBuilder(1, '待办'))
        }
        .vertical(false)
        .barMode(BarMode.Fixed)
        .barWidth(360)
        .barHeight(56)
        .animationDuration(400)
        .onChange((index: number) => {
          this.currentIndex = index
        })

        Button({ stateEffect: true }) {
          Image($r('app.media.add')).width(65).height(65).objectFit(ImageFit.Contain)
        }
        .visibility(this.vis)
        .onClick(() => {
          if (this.currentIndex == 0) {
            router.pushUrl({
              url: 'pages/NoteBook',
              params: {
                index: 0,
                add: true
              }
            }, router.RouterMode.Single)
          }
        })

        .position({
          x: this.position_x,
          y: this.position_y
        })
        .width(65)
        .height(65)
        .borderRadius(90)
        .shadow({
          radius: 10,
          color: Color.Gray,
          offsetX: 5,
          offsetY: 5
        })
        .markAnchor({
          x: '100%',
          y: '100%'
        })
        .margin(10)
        .backgroundColor(0x00000)
        .onDragStart(() => {
          this.vis = Visibility.None;
          return this.photo()
        })
        .onDrop((event: DragEvent) => {
          this.position_x = event.getX()
          this.position_y = event.getY() - this.xxx - this.xx1;
          this.vis = Visibility.Visible
        })
      }
    }
    .backgroundColor('#e4f7fd')
    .width('100%')
    .height('100%')
  }

  @Builder
  photo() {
    Image($r('app.media.add')).width(65).height(65).objectFit(ImageFit.Contain)
  }
}