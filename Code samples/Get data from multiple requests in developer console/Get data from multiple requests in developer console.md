# Get data from multiple requests in developer console

> Published by OAM.

## What is this?

A nifty trick when you want to retrieve a lot of data from the developer console. This is one for the weirder use cases. In my case to retrieve the JSON-response from a large number of requests to use as sample data.

Based on [this SO-post](https://stackoverflow.com/questions/57764902/copy-multiple-network-responses-in-chrome-devtools-network-console)

## How do I use it?

- Open the developer console and go to the network tab
- Filter the requests as needed
- Press CTRL + SHIFT + I to open a developer console for the developer console ( **I know! :D** )
- Run the script below in the console
- Rejoice!

(The script can be modified as needed of course. )

```javascript
(async () => {
  const getContent = r => r.url() && !r.url().startsWith('data:') && r.contentData();
  const nodes = UI.panels.network.networkLogView.dataGrid.rootNode().flatChildren();
  const requests = nodes.map(n => n.request());
  const contents = await Promise.all(requests.map(getContent));
  const looks = contents.map((data, i) => {
    return contents;
  });
  console.log(looks);
})();

```
