import pathlib
from PIL import Image

filepath = str(pathlib.Path(__file__).parent.resolve())

def gen_tile(tile_img):
    res = "dw "

    for y in range(8):
        lsb = ""
        msb = ""

        for x in range(8):
            tile = "3" if tile_img[x, y][3] else "0"

            if tile == "0":
                lsb += "0"
                msb += "0"
            elif tile == "1":
                lsb += "1"
                msb += "0"
            elif tile == "2":
                lsb += "0"
                msb += "1"
            elif tile == "3":
                lsb += "1"
                msb += "1"
            else:
                raise Exception(f"Invalid Character: {tile}")
        
        res += f"${int(lsb, 2):02x}{int(msb, 2):02x}, "

    return res[:-2]

def read_img(filename):
    im = Image.open(filepath + "/" + filename) # Can be many different formats.
    
    pix = im.load()
    w, h = im.size

    for y in range(h // 8):
        for x in range(w // 8):
            yield im.crop( (8*x, 8*y, 8*(x+1), 8*(y+1)) ).load()



fontfiles = {
    "chars": "tiles/chars.png",
    "nums": "tiles/nums.png",
    "symbols": "tiles/symbols.png"
}

# gen chars
alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
abc_chars = read_img(fontfiles["chars"])

symbols = [ "space", "CH", "arrow", "bang" ]
sym_chars = read_img(fontfiles["symbols"])

nums = "0123456789"
num_chars = read_img(fontfiles["nums"])

print('Section "HEX TILES", ROM0')
print('HEX_TILES::')

print(".symbols")
for i, sym in enumerate(symbols):
    print(f".{sym}")
    print(f"  {gen_tile(next(sym_chars))}")

print(".hex")
for i, num in enumerate(nums):
    print(f".{num}")
    print(f"  {gen_tile(next(num_chars))}")

print(".chars")
for i, letter in enumerate(alphabet):
    print(f".{letter}")
    print(f"  {gen_tile(next(abc_chars))}")
