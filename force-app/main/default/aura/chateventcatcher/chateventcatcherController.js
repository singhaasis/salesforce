({
    onNewMessage: function(cmp, evt, helper) {
        var recordId = evt.getParam('recordId');
        var content = evt.getParam('content');
        var name = evt.getParam('name');
        var type = evt.getParam('type');
        var timestamp = evt.getParam('timestamp');

        console.log("recordId:" + recordId + " content:" + content + " name:" + name + " timestamp:" + timestamp);
    }
})