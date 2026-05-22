#!/usr/bin/env bash
# fetch_free_assets.sh — downloads MindHause Phase 1 free CC0 assets
# Idempotent: re-running skips files already present.
# All targets gitignored under godot_palace/assets/.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ASSETS="$ROOT/godot_palace/assets"
STAGING="$ASSETS/_staging"
mkdir -p "$STAGING" \
  "$ASSETS/materials/polyhaven" \
  "$ASSETS/materials/ambientcg" \
  "$ASSETS/models/plants" \
  "$ASSETS/models/quaternius" \
  "$ASSETS/models/kenney"

CURL=(curl -fL --retry 3 --connect-timeout 30 --max-time 600)

# ---- Poly Haven materials (4K JPG: diffuse + nor_gl + arm + rough) ----
PH_TEXTURES=(
  marble_01 wood_floor dark_wood castle_brick_01
  painted_plaster_wall floral_jacquard brown_leather
  japanese_sycamore herringbone_parquet wood_floor_worn
)

ph_fetch_texture() {
  local slug="$1"
  local dest="$ASSETS/materials/polyhaven/$slug"
  mkdir -p "$dest"
  local meta="$STAGING/${slug}_files.json"

  echo ">>> Poly Haven: $slug"
  if [[ ! -s "$meta" ]]; then
    "${CURL[@]}" -s "https://api.polyhaven.com/files/$slug" -o "$meta"
  fi

  for map in Diffuse nor_gl arm Rough; do
    local url
    url=$(python3 -c "
import json, sys
d=json.load(open('$meta'))
m=d.get('$map',{})
res=m.get('4k') or m.get('2k') or m.get('1k') or {}
fmt=res.get('jpg') or res.get('png') or {}
print(fmt.get('url',''))
")
    if [[ -z "$url" ]]; then
      echo "    skip $map (not available)"
      continue
    fi
    local fname
    fname=$(basename "$url")
    if [[ -s "$dest/$fname" ]]; then
      echo "    have $map ($fname)"
    else
      echo "    fetch $map ($fname)"
      "${CURL[@]}" -s "$url" -o "$dest/$fname"
    fi
  done
}

# ---- Poly Haven plants (GLB 2K) ----
PH_PLANTS=(potted_plant_04 calathea_orbifolia_01)

ph_fetch_plant() {
  local slug="$1"
  local dest="$ASSETS/models/plants/$slug"
  mkdir -p "$dest"
  local meta="$STAGING/${slug}_files.json"

  echo ">>> Poly Haven plant: $slug"
  if [[ ! -s "$meta" ]]; then
    "${CURL[@]}" -s "https://api.polyhaven.com/files/$slug" -o "$meta"
  fi

  # Download all gltf 2k files (single GLB + textures)
  python3 -c "
import json, sys
d=json.load(open('$meta'))
g=d.get('gltf',{}).get('2k') or d.get('gltf',{}).get('1k') or {}
files=g.get('gltf',{})
include=files.get('include',{})
out=[(files.get('url',''), files.get('size',0))]
for k,v in include.items():
    out.append((v.get('url',''), v.get('size',0)))
for u,s in out:
    if u: print(u)
" | while read -r url; do
    [[ -z "$url" ]] && continue
    local fname; fname=$(basename "$url")
    if [[ -s "$dest/$fname" ]]; then
      echo "    have $fname"
    else
      echo "    fetch $fname"
      "${CURL[@]}" -s "$url" -o "$dest/$fname"
    fi
  done
}

# ---- AmbientCG (2K PNG) ----
AMBIENT_IDS=(Marble012 Travertine001 Bricks097)

acg_fetch() {
  local id="$1"
  local dest="$ASSETS/materials/ambientcg/$id"
  mkdir -p "$dest"
  local zip="$STAGING/${id}_2K-PNG.zip"

  echo ">>> AmbientCG: $id"
  if [[ -f "$dest/.extracted" ]]; then
    echo "    have $id (extracted)"
    return
  fi
  if [[ ! -s "$zip" ]]; then
    echo "    fetch ${id}_2K-PNG.zip"
    "${CURL[@]}" -s "https://ambientcg.com/get?file=${id}_2K-PNG.zip" -o "$zip"
  fi
  echo "    extract"
  unzip -oq "$zip" -d "$dest"
  touch "$dest/.extracted"
  rm -f "$zip"
}

# ---- Run ----
echo "============== Poly Haven materials =============="
for t in "${PH_TEXTURES[@]}"; do ph_fetch_texture "$t"; done

echo "============== Poly Haven plants =============="
for p in "${PH_PLANTS[@]}"; do ph_fetch_plant "$p"; done

echo "============== AmbientCG materials =============="
for a in "${AMBIENT_IDS[@]}"; do acg_fetch "$a"; done

echo ""
echo "============== Done =============="
echo "Total bytes in assets:"
du -sh "$ASSETS"/{materials,models}/* 2>/dev/null | sort -k1 -h
