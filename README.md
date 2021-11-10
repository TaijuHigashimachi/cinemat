![ogp_default](https://user-images.githubusercontent.com/46441090/140848622-5d2352ac-2df4-4e0d-ba47-857f03d24e6f.png)

## 1．URL
https://cinematrailer.herokuapp.com

## 2．サービス概要
シネマトは「シネマ（映画）のトレイラー（予告）」の略で、映画の予告動画をメインコンテンツにした、映画探索サービスです。  
カンタンにいうと、予告のYouTube動画がズラーッと並んでいて、スクロールとタップだけでカンタンに視聴できるサービス。
  
### Qiitaに少しだけ詳細を追記した記事を投稿しました。
https://qiita.com/taiju365/items/be126c437e9831685fd7

### なぜこのサービスをつくったのか、その想いと経緯をnoteに投稿しました。
https://note.com/taiju365/n/naba8d1d016e5

  
## 3．主な機能

### トップページ
![cac60c3792c25af008cbc94659a93078 (1)](https://user-images.githubusercontent.com/46441090/140849583-cf345c6f-c1cb-4f95-a370-f71806dae2a2.gif)

- **初回チュートリアル**
    - 未ログインユーザーかつ、クッキーに情報が無い場合、初回チュートリアルが表示されます
- **「あらすじを見る」ボタン**
    - ネタバレを見たくない人のために、デフォルトで非表示にしたかったので導入しました
- **インフィニット・スクロール**
    - Twitterのタイムラインのように、画面をスクロールするとページが読み込まれる機能
    - YouTubeの埋め込みタグは重く、また作品数が300と多いため、導入しました
- **ウォッチリスト機能**
    - 各作品を「観たい」「観た」「興味なし」に振り分けられます
    - ウォッチリストに登録した作品は、トップページに表示されなくなります
    - ユーザー登録をすると、ウォッチリスト機能が使えるようになります
- **ユーザーの状況に合わせて、作品の表示をわける**
    - ユーザーがログインしているかどうか、クッキーにこのサービスの情報があるかどうかで、表示される作品をわけました

### マイページ
![28d0f04c6fc998fe77f13ef2be7aa4b6 (1)](https://user-images.githubusercontent.com/46441090/140849970-f20c3b80-7e20-4400-ae80-0899e6bb7ab0.gif)

- **インフィニット・スクロール**
    - ウォッチリストへの登録数が増えると、処理が重くなってしまうため、導入しました
- **プロフィール編集**
    - ユーザーがプロフィール画像を設定できた方が、サービスへの愛着を感じてもらえると考えて導入しました
- **ウォッチリストのステータスの変更**
    - 各作品の登録を解除したり、「観たい」から「観た」に変更などステータスの切り替えができます

### 管理画面
![c4fb8eb84356f5a33d5fa587e310fe32](https://user-images.githubusercontent.com/46441090/140850120-212f516f-98d8-40ca-b917-2b038b448649.png)
  
**APIから取得した映画データの保存機能**
このサービスで使用している映画情報はすべて、[The Movie Database](https://www.themoviedb.org/?language=ja)という映画データベースのAPIから取得しています。  
APIから映画を検索してデータベースに保存、という作業の間に画面遷移をしたくなかったので、1つの画面内で検索・編集・保存ができるようにしました
  
![022522806567d5e0d8f51a7f18f9ca34](https://user-images.githubusercontent.com/46441090/140850238-636236ca-2ddb-4f71-a64c-af2a5ec2cd31.gif)

## 4．ER図
![a6f70be0b1a44d8a08b96f258dce0d9b](https://user-images.githubusercontent.com/46441090/140849134-1f6571a7-5e70-4d74-b12d-0262b6e67c01.png)

### moviesテーブル
APIから取得した、各映画の情報を保存するテーブル。

- **id**
- **api_id**
    - API側で割り当てている各映画のID
- **title**
- **runtime**
    - 上映時間
- **user_score**
    - 映画データベース上のユーザースコア
- **release_date**
    - 公開日
- **orverview**
    - 映画の概要、あらすじ
- **poster_url**
    - ポスター画像のurl
    - ユーザーが増えたら、ポスター画像を使った機能を追加予定
- **trailer_url**
    - YouTube上の、予告動画のID

### genresテーブル、movie_genresテーブル
各映画のジャンルと、それぞれの組み合わせを保存するテーブル。

### usersテーブル
Gemの`Srocery`を使ったユーザー認証と、パスワードリセット機能に必要なカラムを作成。

### movie_statusesテーブル
ユーザーのウォッチリスト登録状況を保存するテーブル。
「観たい」「観た」「興味なし」の値を`enum`で管理。

```
enum status: { default: 0, watch: 1, watched: 2, uninterested: 3 }
```

## 5．主な使用技術

### バックエンド
- Ruby 3.0.2
- Rails 6.0.3.7

### フロントエンド
- HTML
- CSS（SCSS）
- JavaScript（jQuery）
- Bootstrap5
- Font Awesome

### Gem
- High Voltage
    - 静的ページの作成
- Pagy
    - ページネーション
    - Kaminariよりもパフォーマンスが優れているということで選定
- jpmobile
    - PCとスマホで、一部表示わけをしたかったので導入
- Sorcery
    - ログイン、パスワードリセット
- pre-commit
    - コミット時にrubocopを走らせる
- SimpleCov
    - カバレッジ計測(　現在、85.51%)

### プラグイン
- Infinite Scroll

### インフラ
- AWS S3
- Heroku

### CIツール
- GitHub Actions
    - プッシュしたときに、Rspecを走らせたかったため導入

### API
- [The Movie Database](https://www.themoviedb.org/?language=ja)
    - Wikipediaのように、ユーザーが作成する映画データベース
    - 映画情報の登録に使用
