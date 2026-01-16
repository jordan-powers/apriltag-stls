from pathlib import Path
from argparse import ArgumentParser
import shutil
import subprocess

from PIL import Image

OPENSCAD_EXE=r"C:\Users\jordan\Downloads\OpenSCAD-2025.10.17-x86-64\OpenSCAD-2025.10.17-x86-64\openscad.exe"
SCRIPT_DIR = Path(__file__).parent

parser = ArgumentParser()
parser.add_argument("--family", default="36h11")
parser.add_argument("--start", type=int, default=1)
parser.add_argument("--end", type=int, default=32)

args = parser.parse_args()

out_dir = Path("out") / args.family
if out_dir.is_dir():
    shutil.rmtree(out_dir)
out_dir.mkdir(parents=True)

def cvt_svg(in_png: Path, out_svg: Path):
    assert in_png.is_file()
    assert in_png.suffix == ".png"
    assert not out_svg.exists()
    assert out_svg.suffix == ".svg"

    img = Image.open(in_png).convert("L")
    width, height = img.size
    img_data = img.load()

    with(out_svg.open("w") as outf):
        outf.write('<?xml version="1.0" standalone="yes"?>\n')
        outf.write('<svg width="6.5in" height="6.5in" viewBox="0,0,8,8" xmlns="http://www.w3.org/2000/svg">\n')

        for y in range(1, width-1):
            for x in range(1, height-1):
                if img_data[x, y] < 128:
                    outf.write(f'<rect width="1" height="1" x="{x-1}" y="{y-1}" fill="rgba(0, 0, 0, 1.0)" id="box1-1"/>\n')
        outf.write('</svg>')

def gen_stl(id, svg, out_file, selector):
    subprocess.run([
            OPENSCAD_EXE,
            "-o", str(out_file.resolve().as_posix()),
            "-D", f'TAG_PATH="{str(svg.resolve().as_posix())}"',
            "-D", f'TAG_ID={id}',
            "-D", f'SELECTOR={selector}',
            "apriltag-to-stl.scad"
        ], cwd=SCRIPT_DIR)

for i in range(args.start, args.end+1):
    tag = next((SCRIPT_DIR / f'apriltag-imgs/tag{args.family}').glob(f"tag*{i:05d}.png"))
    svg = out_dir / f'{i:05d}.svg'
    base_stl = out_dir / f'{i:05d}_base.stl'
    top_stl = out_dir / f'{i:05d}_top.stl'

    cvt_svg(tag, svg)
    gen_stl(i, svg, base_stl, 1)
    gen_stl(i, svg, top_stl, 0)

    svg.unlink()
