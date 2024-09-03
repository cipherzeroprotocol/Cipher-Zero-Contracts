const TorrentClient = require("../src/lib/torrent/client.js");
const TorrentData = require("../src/lib/torrent/torrentdata/index.js");

async function deployTorrent() {
    const client = new TorrentClient();
    const data = new TorrentData();

    // Example: Create a new torrent
    const torrent = await client.createTorrent({
        files: [/* file data */],
        name: 'example-torrent',
    });

    // Example: Save torrent data
    await data.saveTorrent(torrent);

    console.log('Torrent deployed:', torrent.infoHash);
}

deployTorrent().catch(console.error);
