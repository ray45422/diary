# BeatLinkerぷりむら&MAC枠の裏側でいろいろやってましたの話

12/13～12/15に[BeatLinker](https://beatlinker.net/)というBeat Saberのイベントがありました。

3日目の1部1枠目のぷりむら&MACコラボで裏方をやったのでそこでやったこととか使った諸々について書こうかななんて思ったわけです。つまり自分語りですね。


イベントの様子は公式サイトのスケジュールのダイジェストから見られます。我々の部分は[これ](https://www.twitch.tv/videos/2327319147)です。

## 登場人物

- けしずみ  
これを書いてる人。GitHubのWikiで日記を書いてるらしい。

- ぷりむら  
今回の発起人。アイデア出しから技術的なことまでできる天才。BeatGather、BeatGather Connectの主催。

- MAC  
ぷりむらさんに招集された不憫な大聖女。マッピングとヌンチャクがうまい配信者。ぴゃー

## やったこと

### Camera2とCameraPlusの改造

両方Beat Saberで表示をいろいろするMODで一人称以外のカメラを追加したりできて便利。Beat Saberのアバター文化を支えていそう。

今回はグリーンバックを使用して透過を行ったので不要なオブジェクトをレンダリング対象外にして背景色を緑にするように改造しました。前にBeatGather Connectではグリーンバックな環境を使わせるというあまりにも非人道的なことをした反省を生かしています。設定ファイルからしか挙動を変えられないので現状配布には耐えない品質。

あとは背景素材用に床をいじったりできる機能を突っ込んだりしました。別でMODを作るべきなんだろうけどめんどくさかった。

### TournamentAssistantの魔改造

TournamentAssistant(以下TAとする)は名前の通り対戦を行うに当たって便利な機能を適用してくれるMODですが、複数のプレイヤーの配信のラグを吸収して同時にプレイしているようにできる機能が目当てです。

これとグリーンバックを使うことで同時に同じ空間でプレイしているかのように見えるわけですね。

同時にプレイはできてもグリーンバックで背景をなくして同じ背景だと面白くないので後ろで動画素材を流せるようにしたいですよね。というわけでOBS上のメディアソースを同期して再生する機能を追加しました。OBSにはWebSocketでいろいろできる機能があるのでそれでいい感じにやってます。

もともと競技用なので全員が同じ譜面をプレイすることが想定されていますが、今回のようなパフォーマンスではそれぞれ違う譜面をプレイすることになります。なので同じ譜面でも別の難易度をプレイヤーごとに選択できる機能を追加しています。これはもともとぷりむらさんが主催のBeatGather用に やす さんが改造していたものを参考に実装しています。非常に助かっています。

TAの難易度設定画面では難易度のカスタム表示が出てきません。HardとかExpertとか書かれても普段見てる表記じゃないのでよくわかりませんよね。絶対に事故ると思ったのでカスタムラベルを表示できるように変更しています。

こんないろいろ改造したTAですが新バージョンは全く違うものになりそうなので新しいBeat Saberでやるにはまた頑張る必要が出てくるのかもしれないですね。

### OBS

クロマキーでパーティクルが全然きれいに抜けません。Unityでシェーダーを書いたりしたけど僕はアホなので全然うまくいきませんでした。なのでパーティクルを減らして上からエフェクトの動画を載せようなんて思っていました。ところが本番の5時間前にぷりむらさんがクロマキーのシェーダーを書いてきてこれで行くことに。やっぱり天才は一味違う。これ僕がやったことじゃないな。

魔改造TAの仕様上シーン構成にはいろいろ制約(OBSのWebSocket経由では非表示のメディアソースの操作ができない)があるのでちょっと苦労した。そもそも普段まともに配信してないので基本がよくわからない。

StreamDeck+を導入していたのでシーントランジションはそれに割り当てて、各種音量もダイヤルに割り当てていたので直前の音量調節で思ったより下げる必要があったのに対応できてよかった。あると便利ですStreamDeck。

トランジションの動画は音量調整できなかったので爆音で申し訳ない。あとなぜか二回連続で流れたりもした。

### 衣装対応

ぷりむらさんの鶴の一声によりサンタ服を着ることになったのでいい感じの衣装をお二人の素体に合わせました。可愛かったですね。

## あとがき

いかがでしたか。裏側を見て見ると意外とそんなに難しいことはなくてただただめんどくさいだけですね。

今回はクオリティや演出などの問題で動画多めでしたが、準備期間がある程度確保できて当日誰かひとり調整をできる人がいればライブでのコラボができます。

是非みなさんもやってみませんか。