import router from '@ohos.router'
@Entry
@Preview
@Component
struct NoteBook {
  @State message: string = 'Hello World'
  @State text: string = ''
  build() {
    Column() {
      Row() {
        Image($r('app.media.back'))
          .width(70)
          .height(35)
          .margin({left:10,top:5})
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            router.back()
          })
        Blank()
        Image($r('app.media.yes'))
          .width(70)
          .height(40)
          .margin({top:5,right :10})
          .objectFit(ImageFit.Contain)
      }.width('100%')
      TextArea({text:this.text}).height('75%').width('100%').fontSize(30).onChange((value:string)=>{
        this.text = value
      })
      Text('上传图片').width('100%').fontSize(20)
      Row(){
        Image($r('app.media.app_icon')).height(100).width(100).objectFit(ImageFit.Contain).margin({right:10}).padding(2).border({width:2,color:Color.Grey})
        Image($r('app.media.app_icon')).height(100).width(100).objectFit(ImageFit.Contain).padding(2).border({width:2,color:Color.Grey})
      }.margin({top:20}).width('90%')
    }
    .height('100%')
  }
}