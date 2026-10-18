# Docker Compose の OWASP WebGoat ラボ：WebWolf 付きの Web セキュリティ ガイド付きレッスンを、専用のコピーで

[English](README.md) | [Français](README.fr.md) | [日本語](README.ja.md) | [Español](README.es.md)

[![check](https://github.com/mitsurutech/lab-webgoat/actions/workflows/check.yml/badge.svg)](https://github.com/mitsurutech/lab-webgoat/actions/workflows/check.yml)

授業でそのまま使える **Web アプリケーションセキュリティのラボ**です。[MitsuruTech ラーニングプラットフォーム](https://mitsurutech.co.uk/ja/learning)が提供するもので、学校では生徒ごとに専用のデータベース、コンテナー、ターミナルをブラウザーで使えます。生徒は一人ひとり **OWASP WebGoat** の専用コピーを受け取ります。WebGoat は、インジェクション、アクセス制御の不備、安全でないデシリアライゼーション、JWT の誤り、パストラバーサルなどの弱点を1つずつ説明し、生徒に実際に突かせるガイド付きレッスンのコースで、第三者が必要なレッスンのために **WebWolf** も横に用意されています。最初の入門や家庭学習の課題に向いており、何もインストールせず、ほかの誰かのマシンに危険が及ぶこともありません。

`docker-compose` ファイル `compose.yaml` 1つだけで、自分のマシンでもプラットフォームでも同じように動きます。プラットフォームでは、生徒ごとにインターネットへの出口がない専用のコピーが用意されます。

## 守るべきルールは1つ

**攻撃してよいのは自分のコピーだけです。** このラボのすべては、インターネットにも他の生徒にも経路がない自分専用のコピーの中で動くので、届くのはラボが起動したアプリケーションだけです。自分のものではない Web サイト、ネットワーク、マシンに対しては、ラボの中でもそれ以外でも、決してツールを向けないでください。英国では[Computer Misuse Act 1990](https://www.legislation.gov.uk/ukpga/1990/18/contents)により犯罪となり、多くの国に同様の法律があります。弱点の仕組みを学ぶことは、弱点のないソフトウェアを作ることにつながります。授業の最初の話題には、このルールがなぜあるのかと、責任ある開示とは何かがふさわしいでしょう。

## 中身

| サービス | イメージ | メモリ | 内容 |
| --- | --- | --- | --- |
| `webgoat` | [`webgoat/webgoat:v2026.5`](https://hub.docker.com/r/webgoat/webgoat) | 1 GB | WebGoat と WebWolf（Java アプリケーション）。権限のないアカウント（1001）で、capability なしで動きます |
| `web` | [`nginx:1.27-alpine`](https://hub.docker.com/_/nginx) | 64 MB | 手前に置く小さなプロキシ |

プロキシがある理由は1つだけです。WebGoat は `/` で 404 を返し、`/WebGoat` にあるため、ラボのリンクを開くとエラーページになってしまいます。プロキシは `/` を `/WebGoat/` に転送し、それ以外はブラウザー自身のアドレスのまま通します。WebGoat は Java アプリケーションなので、3つのセキュリティラボの中で最も多い 1 GB を割り当てています。起動に約7秒かかり、軽く使っているときは約 450 MB を使います。

イメージはサードパーティ製のプログラムで、各プロジェクトが公開している公式イメージを改変せずに実行し、バージョンを固定しています（`latest` は使いません）。そのため、授業の途中でレッスンごとにラボが変わることはありません。ここでは何もビルドせず、このリポジトリのものはイメージに含まれません。

## プラットフォームで使う

[MitsuruTech ラーニングプラットフォーム](https://mitsurutech.co.uk/ja/learning)では、生徒ごとにラボの専用コピーがブラウザーで使え、横にターミナルも付きます。

**試すには：** [コンテナーのページ](https://mitsurutech.co.uk/ja/container)を開き、**サンプルラボ**からこのラボを探して「起動」を押します。試すだけならアカウントは不要です。

**クラスの課題として出すには：**

1. モジュールで種類が**ラボ**の課題を作り、**GitHub リポジトリ**を選びます。
2. `https://github.com/mitsurutech/lab-webgoat` とブランチ `main` を指定します。compose ファイルは既定の `compose.yaml` です。ファイルを変えたいときは、先にリポジトリをフォークしてください。
3. 公開します。各生徒のコピーは公開したコミットから始まるので、あとでここを変更しても、すでに出したラボは変わりません。
4. 課題に何を提出するかを書き（[教員向け](#教員向け)を参照）、ほかの課題と同じように配布します。

マニュアルの[セキュリティラボのガイド](https://mitsurutech.co.uk/ja/help/security-labs)と[コンテナーラボのガイド](https://mitsurutech.co.uk/ja/help/labs)に、そのほかの説明があります。compose ファイルに書けること、1つのコピーに割り当てられるメモリ、教員が生徒のコピーを開いて確認し採点する方法などです。

学校のアカウントがまだありませんか。[最初の1年は無料](https://mitsurutech.co.uk/ja/pricing)で、生徒50人まで使えます。[登録](https://mitsurutech.co.uk/ja/signup)にはメールアドレスだけが必要です。

## 自分のマシンで動かす

Docker と Compose プラグインが必要です。初回の起動ではイメージをダウンロードします。

```bash
docker compose -f compose.yaml -f local.yaml up
```

WebGoat は <http://localhost:8080/WebGoat>、WebWolf は <http://localhost:9090/WebWolf> を開きます。

`local.yaml` はポートを `127.0.0.1` だけに公開するので、ラボには自分のコンピューターからだけアクセスでき、ほかからは届きません。`Ctrl-C` で停止し、`docker compose -f compose.yaml -f local.yaml down -v` で削除します。アプリケーションは意図的に脆弱なので、攻撃用に使ってもよいマシンで動かしてください。

## 進め方

1. **登録する。** WebGoat を開いて **Register** を選び、このコピー用のユーザー名とパスワードを決めます。
2. **レッスン一覧の先頭から始める。** 各レッスンは、インジェクション、アクセス制御の不備、安全でないデシリアライゼーション、JWT の誤り、パストラバーサルなどの弱点を説明し、それを実際に突くよう求めます。成功するとレッスンが完了になります。
3. **レッスンの指示があれば WebWolf を使う。** このラボには WebGoat と WebWolf の2つのリンクがあり、WebWolf は、メッセージが送られてくるレッスンなど、第三者が必要なレッスン用です。同じアカウントでログインします。
4. **進捗はラボが動いている間だけ続きます。** ラボを停止すると保存されません。

## 教員向け

このラボには自動採点はありません。生徒が証拠を提出し、教員がほかのラボと同じように採点します。

**証拠は2つに分けて求めます。** 1つ目は作業の証拠です。完了したレッスンごとのスクリーンショット。ブラウザーにラボ自身のアドレスが写っていて、その生徒のコピーだとわかるものを求めます。2つ目は理解の確認です。それぞれについて、弱点が何か、使った入力そのものとそれが成功した理由、攻撃者がそれで何をできるか、コードをどう書くべきだったかを、自分の言葉で書いた説明で求めます。後者を見れば、理解したのか、解説記事の写しなのかがわかります。より高い水準を求めるなら、攻撃だけでなく修正も求めてください。

**コースのどこに合うか。** WebGoat は、弱点の種類ごとの最初の入門に向いています。説明が横にあり、暗号、トークン、デシリアライゼーションの基礎にも合います。ユニットの法律と倫理の面、つまり許可と範囲、Computer Misuse Act 1990、責任ある開示にも役立ちます。正確な文言は、お使いの認定団体のユニットで確認してください。ここでは引用していません。

**誰が何を見られるか。** このようなラボは16～17歳の生徒に使われることが多くあります。コピーは起動した生徒だけのものです。そのモジュールを教える教職員は、生徒が何をしたかを見るためにコピーを開けます。生徒の作業を開いた記録はアクセスログに残り、生徒も読めます。

## ラボで動かないこと

WebGoat の進捗は、ラボが動いている間だけ続きます。ラボにはインターネットへの出口がないので、インターネット上のサイトが必要なレッスンは完了できません。WebGoat は Java アプリケーションで、3つのセキュリティラボの中で最も多い 1 GB を割り当てており、ほかより起動に数秒長くかかります。

## トラブルシューティング

- **起動した直後にログインページが表示されない。** 数秒待ってからもう一度「開く」を押してください。ラボは、WebGoat がプロキシ越しに応答して初めて準備完了と表示します。
- **2つ目のリンクの WebWolf にログインできない。** 先に WebGoat で登録し、同じアカウントで WebWolf にログインしてください。
- **自分のマシンでポート 8080 または 9090 がすでに使われている。** `local.yaml` の左側の番号を変えて、そのポートを開いてください。

## ラボのチェック

`test/check.sh` は、プラットフォームのランナーが各サービスを起動するのと同じ方法（すべての capability を外す、`no-new-privileges`、プロセス数の上限、メモリの上限、インターネットへの出口なし）でラボを起動し、このページが約束していることをネットワークの内側から確認します。Docker が必要で、push のたびに実行されます。ページの上部のバッジがそれです。

```bash
test/check.sh
```

## バージョンとサードパーティのライセンス

[WebGoat](https://github.com/WebGoat/WebGoat) のライセンスは GPL-2.0、[nginx](https://nginx.org) は BSD-2-Clause です。イメージは `webgoat/webgoat:v2026.5` と `nginx:1.27-alpine` です。

## ライセンス

この作品は [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/) でライセンスされています。Mitsuru Technologies Ltd のクレジットを表示し、商用に使わず、これをもとに作ったものを同じライセンスで共有するなら、学習と授業のために共有・改変できます。全文は `LICENSE` ファイルにあります。対象は compose ファイル、テスト、このドキュメントです。中のアプリケーションには、上にリンクした各プロジェクト自身のライセンスが適用されます。

## このリポジトリについて

[Mitsuru Technologies](https://mitsurutech.co.uk) が[MitsuruTech ラーニングプラットフォーム](https://mitsurutech.co.uk/ja/learning)のために作りました。学校向けに、Python、Java、Go、Node、SQL、Linux をブラウザーで学べ、コンテナーラボ、GitHub から Web アプリをデプロイする機能、自動採点のクイズがあります。アカウントなしでコードを試せる[プレイグラウンド](https://mitsurutech.co.uk/ja/playground)もあります。日本語での研修とサポートもご用意しています。

同じ提供元のほかのラボ：[lab-juice-shop](https://github.com/mitsurutech/lab-juice-shop)、[lab-dvwa](https://github.com/mitsurutech/lab-dvwa)、[lab-webgoat](https://github.com/mitsurutech/lab-webgoat)、[lab-mysql-phpmyadmin](https://github.com/mitsurutech/lab-mysql-phpmyadmin)、[lab-git-gitea](https://github.com/mitsurutech/lab-git-gitea)、[lab-sample](https://github.com/mitsurutech/lab-sample)。
