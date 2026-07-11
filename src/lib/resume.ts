import data from '../../resume.json';

// The templates defensively read optional JSON Resume fields that aren't present
// on every entry (or any, yet). Importing the JSON directly makes TypeScript infer
// a narrow shape from the current data, so we cast to this schema once here and let
// the site read from a typed source.

export interface Basics {
  name: string;
  label?: string;
  email?: string;
  phone?: string;
  summary?: string;
  location?: { city?: string; region?: string };
}

export interface Work {
  name: string;
  position: string;
  url?: string;
  startDate?: string;
  endDate?: string;
  summary?: string;
  highlights?: string[];
}

export interface Education {
  institution: string;
  studyType: string;
  area: string;
  startDate?: string;
  endDate?: string;
  score?: string;
}

export interface Skill {
  name: string;
  keywords: string[];
}

export interface Project {
  name: string;
  url?: string;
  description?: string;
  keywords?: string[];
  highlights?: string[];
}

export interface Resume {
  basics: Basics;
  work: Work[];
  education: Education[];
  skills: Skill[];
  projects: Project[];
}

export const resume = data as Resume;
