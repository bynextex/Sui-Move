module examples::video_nft {
    use sui::url::{Self, Url};
    use std::string;
    use sui::object::{Self, ID, UID};
    use sui::event;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    /// NFT'yi temsil eden struct
    struct VideoNFT has key, store {
        id: UID,
        /// Video adi
        name: string::String,
        /// Video URL
        url: Url,
    }

    // ===== Events =====

    struct NFTMinted has copy, drop {
        // NFT'nin Object ID'si
        object_id: ID,
        // NFT'yi oluşturan kullanıcının adresi
        creator: address,
        // NFT'nin adı
        name: string::String,
    }

    // ===== Public view functions =====

    /// NFT'nin `name` özelliğini al
    public fun name(nft: &VideoNFT): &string::String {
        &nft.name
    }

    /// NFT'nin `url` özelliğini al
    public fun url(nft: &VideoNFT): &Url {
        &nft.url
    }

    // ===== Entrypoints =====

    /// Yeni bir video NFT'si oluştur
    public entry fun mint_video_nft(
        video_name: vector<u8>,
        video_url: vector<u8>,
        ctx: &mut TxContext
    ) {
        let sender = tx_context::sender(ctx);
        let nft = VideoNFT {
            id: object::new(ctx),
            name: string::utf8(video_name),
            url: url::new_unsafe_from_bytes(video_url),
        };

        event::emit(NFTMinted {
            object_id: object::id(&nft),
            creator: sender,
            name: nft.name,
        });

        transfer::public_transfer(nft, sender);
    }
}