import { createClient } from '@supabase/supabase-js'

const supabaseUrl = 'https://cukaewahtyvircempvpm.supabase.co'
const serviceRole = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN1a2Fld2FodHl2aXJjZW1wdnBtIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY4MTc0MDg4NCwiZXhwIjoxOTk3MzE2ODg0fQ.1fh3s9kBEdkxwGVGL5foCZPTYMgHkSN3hmDUzE7MCNQ'
//const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN1a2Fld2FodHl2aXJjZW1wdnBtIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODE3NDA4ODQsImV4cCI6MTk5NzMxNjg4NH0.rhqXefu1VTn7d2w965NLgMM1qDh-OUCjzZdY9ovU2Zs'
const supabase = createClient(supabaseUrl, serviceRole)

export default supabase;
 //serviceRole = eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN1a2Fld2FodHl2aXJjZW1wdnBtIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY4MTc0MDg4NCwiZXhwIjoxOTk3MzE2ODg0fQ.1fh3s9kBEdkxwGVGL5foCZPTYMgHkSN3hmDUzE7MCNQ