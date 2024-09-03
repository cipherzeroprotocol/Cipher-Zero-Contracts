const TorrentClient = require("../src/lib/torrent/client.js");
const TorrentData = require("../src/lib/torrent/torrentdata/index.js");

async function interactTorrent() {
    const client = new TorrentClient();
    const data = new TorrentData();

    // Example: Load a torrent
    const torrent = await data.loadTorrent('example-torrent-hash');

    // Example: Start downloading the torrent
    client.downloadTorrent(torrent);

    console.log('Started download for:', torrent.infoHash);
}

interactTorrent().catch(console.error);
