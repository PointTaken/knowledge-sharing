Trustworthy wait-method you can use when you need to wait for something out of your control to initialize.

**Simple helper function to sleep for a given number of milleseconds**

```javascript
export const sleep = async (ms: number) => {
  return new Promise((resolve) => setTimeout(resolve, ms));
};

```

**Usage:**

```javascript
// Some code you don't know when is ready, but definitely maybe before a second has passed

await sleep(1000);

// Continue as you were
```