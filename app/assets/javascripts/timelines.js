$(function(){
  $('form.input_message_form input.post').click(function(e){
    // 「Post」ボタンは非Ajaxにする
    var form = $('form.input_message_form');
    form.removeAttr('data-remote');
    form.removeData("remote");
    form.attr('action', form.attr('action').replace('.json', ''));
  });

  $('form.input_message_form').on('ajax:complete', function(event, data, status){
    // Ajaxレスポンス
    if ( status == 'success') {
      var json = JSON.parse(data.responseText);
    // 基本課題15　ADD
      // $('div.timeline').prepend(json.timeline);
      // 正常な場合はjson.timelineを挿入
      // console.log(json);
      // $('div.timeline').prepend(json.timeline);
      if (json.timeline) {
        $('div.alert').empty();
        $('div.timeline').prepend(json.timeline);
      }
      else if (json.errors) {
        $('div.alert').empty();
        $('div.alert').append(json.errors);
      }
      else {
        $('div.alert').html('エラーが発生しました');
      }
    }
    // エラーが発生した場合はエラー内容を挿入
    else{
      // ??? timelineではダメ。ajaxを学習してから修正すること！
      // $('div.timeline').prepend(json.timeline);
      // var json = JSON.parse(data.responseText);
      // $('div.actions').append(json.timeline).css('color','red');
      // ここに書くのがそもそも間違い。validationエラーでもsuccessなので。
      $('div.alert').html('エラーが発生しました');
    }
  });
});
