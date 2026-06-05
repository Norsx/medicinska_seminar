import os
import sys
from pypdf import PdfReader

def extract_figures_from_pdf(pdf_path, output_dir, file_prefix, page_range=None, min_size_bytes=40000):
    """
    Extracts images from specified pages of a PDF and saves them to output_dir if they exceed min_size_bytes.
    """
    if not os.path.exists(pdf_path):
        print(f"Error: PDF not found at {pdf_path}")
        return []
    
    print(f"Opening {os.path.basename(pdf_path)}...")
    reader = PdfReader(pdf_path)
    total_pages = len(reader.pages)
    
    if page_range is None:
        pages_to_check = range(total_pages)
    else:
        # 1-indexed input converted to 0-indexed range
        pages_to_check = [p - 1 for p in page_range if 1 <= p <= total_pages]
        
    extracted_paths = []
    image_counter = 1
    
    for page_idx in pages_to_check:
        page = reader.pages[page_idx]
        images_dict = page.images
        
        if not images_dict:
            continue
            
        print(f"  Checking page {page_idx + 1} ({len(images_dict)} image objects found)...")
        
        for img_obj in images_dict:
            img_data = img_obj.data
            size = len(img_data)
            
            if size >= min_size_bytes:
                # Deduce image extension from name or default to png
                ext = 'png'
                if '.' in img_obj.name:
                    ext = img_obj.name.split('.')[-1].lower()
                if ext not in ['png', 'jpg', 'jpeg', 'webp']:
                    ext = 'png'
                
                # Check for duplicates or generate unique filename
                filename = f"{file_prefix}_{page_idx+1}_{image_counter}.{ext}"
                out_path = os.path.join(output_dir, filename)
                
                with open(out_path, 'wb') as f:
                    f.write(img_data)
                
                print(f"    -> Extracted: {filename} (Size: {size / 1024:.2f} KB)")
                extracted_paths.append(out_path)
                image_counter += 1
                
    return extracted_paths

def main():
    # Force UTF-8 terminal output
    sys.stdout.reconfigure(encoding='utf-8')
    
    project_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    sources_dir = os.path.join(project_dir, 'data', 'sources')
    figures_dir = os.path.join(project_dir, 'docs', 'figures')
    
    os.makedirs(figures_dir, exist_ok=True)
    
    # Target PDFs to extract figures from:
    # 1. S3_von_Haxthausen_2021_Review.pdf -> pages 1-6 (general RUS components diagram)
    # 2. H2_IEEE_TRO_2023_Breast.pdf -> pages 1-6 (breast scanning setup & path planning)
    # 3. I1_IEEE_2023_Hybrid_Impedance.pdf -> pages 1-5 (hybrid impedance control loop)
    # 4. A3_Conti_2010_Admittance.pdf -> pages 1-5 (admittance control block diagram)
    
    targets = [
        ('S3_von_Haxthausen_2021_Review.pdf', 'sustav_rus', [1, 2, 3, 4, 5, 6]),
        ('H2_IEEE_TRO_2023_Breast.pdf', 'breast_scan', [1, 2, 3, 4, 5, 6]),
        ('I1_IEEE_2023_Hybrid_Impedance.pdf', 'hybrid_impedance', [1, 2, 3, 4, 5]),
        ('A3_Conti_2010_Admittance.pdf', 'admittance_control', [1, 2, 3, 4, 5])
    ]
    
    print("Starting image extraction from PDF sources...")
    
    all_extracted = []
    for pdf_name, prefix, pages in targets:
        pdf_path = os.path.join(sources_dir, pdf_name)
        extracted = extract_figures_from_pdf(pdf_path, figures_dir, prefix, page_range=pages, min_size_bytes=35000)
        all_extracted.extend(extracted)
        
    print(f"\nDone! Extracted {len(all_extracted)} images to {os.path.relpath(figures_dir, project_dir)}.")

if __name__ == '__main__':
    main()
