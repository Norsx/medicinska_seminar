import os
import re
import sys

def get_tex_files(docs_dir):
    tex_files = []
    for root, _, files in os.walk(docs_dir):
        for file in files:
            if file.endswith('.tex'):
                tex_files.append(os.path.join(root, file))
    return tex_files

def parse_bib_keys(bib_path):
    if not os.path.exists(bib_path):
        print(f"Error: {bib_path} not found.")
        return set()
    
    with open(bib_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Matches @type{key, ...
    pattern = re.compile(r'@\w+\s*\{\s*([^,\s]+)\s*,')
    keys = set(pattern.findall(content))
    return keys

def clean_latex_line(line):
    # Remove comments starting with % (but not \% which is an escaped percent sign)
    # Simple regex approximation
    line = re.sub(r'(?<!\\)%.*', '', line)
    return line

def validate_tex_file(file_path, bib_keys):
    with open(file_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    
    errors = []
    citations = set()
    brace_count = 0
    begin_end_stack = []
    
    for line_idx, raw_line in enumerate(lines, 1):
        line = clean_latex_line(raw_line)
        
        # Check braces
        for char_idx, char in enumerate(line):
            if char == '{' and (char_idx == 0 or line[char_idx-1] != '\\'):
                # Note: in LaTeX, braces can be escaped as \{, but we care about structural braces
                # \{ and \} are usually handled, let's keep it simple
                brace_count += 1
            elif char == '}' and (char_idx == 0 or line[char_idx-1] != '\\'):
                brace_count -= 1
                if brace_count < 0:
                    errors.append(f"Line {line_idx}: Unexpected closing brace '}}'")
                    brace_count = 0 # reset to prevent cascading
        
        # Match \begin{...} and \end{...}
        begins = re.findall(r'\\begin\s*\{([^}]+)\}', line)
        for b in begins:
            begin_end_stack.append((b, line_idx))
            
        ends = re.findall(r'\\end\s*\{([^}]+)\}', line)
        for e in ends:
            if not begin_end_stack:
                errors.append(f"Line {line_idx}: \\end{{{e}}} without matching \\begin")
            else:
                last_b, start_line = begin_end_stack.pop()
                if last_b != e:
                    errors.append(f"Line {line_idx}: Mismatched environment. Found \\end{{{e}}}, expected \\end{{{last_b}}} (started at line {start_line})")
                    
        # Extract citations
        cites = re.findall(r'\\cite\s*\{([^}]+)\}', line)
        for cite in cites:
            # Citations can be comma separated: \cite{key1,key2}
            for part in cite.split(','):
                citations.add(part.strip())
                
    if brace_count != 0:
        errors.append(f"End of file: Unbalanced curly braces (count is {brace_count})")
        
    while begin_end_stack:
        env, line_idx = begin_end_stack.pop()
        errors.append(f"End of file: Unclosed environment \\begin{{{env}}} from line {line_idx}")
        
    # Check if citations exist in BibTeX keys
    missing_citations = []
    for cite in citations:
        if cite not in bib_keys:
            missing_citations.append(cite)
            
    return errors, missing_citations

def main():
    # Setup output encoding to avoid Windows encoding crashes
    sys.stdout.reconfigure(encoding='utf-8')
    
    project_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    docs_dir = os.path.join(project_dir, 'docs')
    bib_path = os.path.join(docs_dir, 'references.bib')
    
    print("Starting LaTeX static validation...")
    bib_keys = parse_bib_keys(bib_path)
    print(f"Loaded {len(bib_keys)} BibTeX citation keys.")
    
    tex_files = get_tex_files(docs_dir)
    print(f"Found {len(tex_files)} TeX file(s) to validate.")
    
    all_ok = True
    for file_path in tex_files:
        rel_path = os.path.relpath(file_path, project_dir)
        print(f"\nValidating {rel_path}...")
        errors, missing_cites = validate_tex_file(file_path, bib_keys)
        
        if errors:
            all_ok = False
            print(f"  [FAIL] Syntactical errors found:")
            for err in errors:
                print(f"    - {err}")
        else:
            print("  [OK] Syntax check passed (braces and begin/end environments are balanced).")
            
        if missing_cites:
            all_ok = False
            print(f"  [FAIL] Missing citations (not found in references.bib):")
            for cite in missing_cites:
                print(f"    - {cite}")
        elif not errors:
            print("  [OK] All cited works are defined in references.bib.")
            
    if all_ok:
        print("\n[SUCCESS] All checks passed successfully.")
        sys.exit(0)
    else:
        print("\n[FAILED] Validation errors were found.")
        sys.exit(1)

if __name__ == '__main__':
    main()
