import { BusinessError, pasteboard } from '@kit.BasicServicesKit';

export function copy(content: string) {
  let systemPasteboard: pasteboard.SystemPasteboard = pasteboard.getSystemPasteboard();
  let pasteData: pasteboard.PasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, content);

  systemPasteboard.setData(pasteData).then(() => {
    console.info('Succeeded in setting PasteData. Copied \"' + content + "\"");
  }).catch((err: BusinessError) => {
    console.error('Failed to set PasteData. Cause: ' + err.message);
  });
}