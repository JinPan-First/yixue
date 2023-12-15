// xxx.ets
import router from '@ohos.router'
import common from '@ohos.app.ability.common'
import abilityAccessCtrl from '@ohos.abilityAccessCtrl'

@Entry
@Component
struct Index {
  @State changeValue: string = ''
  controller: SearchController = new SearchController()
  aboutToAppear() {
    let contexts = getContext(this) as common.UIAbilityContext
    let atManager = abilityAccessCtrl.createAtManager()
    try {
      atManager.requestPermissionsFromUser(contexts, ['ohos.permission.READ_MEDIA', 'ohos.permission.WRITE_MEDIA', 'ohos.permission.INTERNET'])
    } catch (err) {
    }
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.label')).objectFit(ImageFit.Contain).height(200).width(200)
      }.margin({ top: 50 })

      Column() {
        Search({ value: this.changeValue, placeholder: 'Hi,...', controller: this.controller })
          .width('100%')
          .height(40)
          .backgroundColor('#F5F5F5')
          .placeholderColor(Color.Grey)
          .placeholderFont({ size: 14, weight: 400 })
          .textFont({ size: 14, weight: 400 })
          .onChange((value: string) => {
            this.changeValue = value
          })
        List() {

          ListItem() {
            Text('1')
          }

          ListItem() {
            Text('1')
          }

          ListItem() {
            Text('1')
          }

          ListItem() {
            Text('1')
          }

        }
        .borderRadius(20)
        .backgroundColor(Color.White)
        .width('80%')
        .height(60)
        .visibility(this.changeValue.length == 0 ? Visibility.None : Visibility.Visible)

        Button('课表').onClick(() => {

          router.pushUrl({
            url: 'pages/Lesson'
          }, router.RouterMode.Single)
        })
        Button('笔记').onClick(() => {
          router.pushUrl({
            url: 'pages/Note'
          }, router.RouterMode.Single)
        })
      }
      .backgroundColor(this.changeValue.length == 0 ? '#e4f7fd' : Color.White)
      .borderRadius(35)
      .width('80%')
      .margin({ top: 30 })
    }.width('100%').height('100%').backgroundColor('#e4f7fd')
  }
}