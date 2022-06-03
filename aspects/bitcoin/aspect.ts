export default {
  description: 'Sets up tools for exploring the Bitcoin blockchain',
  variables: {
    files: ['.bitcoin/bitcoin.conf', '.config/btc-rpc-explorer.env'],
    packages: [
      'bitcoin-core', // Headless Bitcoin node, use "bitcoin-qt" instead for GUI.
      'btc-rpc-explorer', // Explore Bitcoin blockchain + node state at http://localhost:3002.
    ],
  },
};
