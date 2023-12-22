import { track } from 'lwc';

import BaseChatMessage from 'lightningsnapin/baseChatMessage';
const CHAT_CONTENT_CLASS = 'chat-content';
const AGENT_USER_TYPE = 'agent';
const CHASITOR_USER_TYPE = 'chasitor';
const SUPPORTED_USER_TYPES = [AGENT_USER_TYPE, CHASITOR_USER_TYPE];
const LWC_PREFIX = 'lwc:'
export default class FileUploadExample extends BaseChatMessage {
@track content = '';
showNow=false;
showNoContent=false;
connectedCallback()
{
if(this.messageContent.value.startsWith(LWC_PREFIX))
{
if(this.messageContent.value.split(':')[1]==="Yes")
{
this.showNow=true;
}
else{
this.text='The file upload option is not available';
this.showNoContent=true;
}

}
else{
this.showNoContent=true;
this.text=this.messageContent.value;
}


}
handleUploadFinished() {

const uploadedFiles = event.detail.files;
}
}