#ifndef TableCorresp_h
#define TableCorresp_h

#define MAX_ENTRY 1000
#define MAX_NEIGHBORS 10

class TableCorresp
{
	
	static unsigned short CorrespEntry[MAX_ENTRY] ; 
	static unsigned short CorrespParent[MAX_ENTRY] ; 
	static unsigned short CorrespDepth[MAX_ENTRY]; 
	static unsigned short CorrespAO[16] 
	static bool isFFD[MAX_ENTRY];
	static short params[3];
	
	//New modification : Add neighbor list
 	static unsigned short Neighbors[MAX_ENTRY][MAX_NEIGHBORS];
	//end modification
	
	public:
	
	static unsigned short returnCTAddr(unsigned short entry)
	{
		return CorrespEntry[entry]; 
	}
	
	static void addCTAddr(unsigned short nodeId, unsigned short CTAddr)
	{
		CorrespEntry[nodeId]= CTAddr;
	}
	
	static unsigned short returnCTParent(unsigned short entry)
	{
		return CorrespParent[entry]; 
	}
	
	static void addCTParent(unsigned short nodeId, unsigned short CTParentAddr)
	{
		CorrespParent[nodeId]=CTParentAddr;
	}
	
	static unsigned short returnCTDepth(unsigned short entry)
	{
		return CorrespDepth[entry]; 
	}
	
	static void addCTDepth(unsigned short nodeId, unsigned short CTDepth)
	{
		CorrespDepth[nodeId]=CTDepth;
	}
	
	static short Lm()
	{
		return params[0];
	}
	
	static short Cm()
	{
		return params[1];
	}
	
	static short Rm()
	{
		return params[2];
	}
	static void addParams(short Lm, short Cm, short Rm)
	{
		params[0] = Lm;
		params[1] = Cm;
		params[2] = Rm;
	}
	
	static bool returnIsFFD(unsigned short entry)
	{
		return isFFD[entry];
	}
	static void addIsFFD(unsigned short nodeId, bool ffd)
	{
		isFFD[nodeId]=ffd;
	}
		
	static unsigned short *returnNeighborList(unsigned short entry)
	{
		return Neighbors[entry]; 
	}
	
	static void addNeighbor(unsigned short nodeId, unsigned short num, unsigned short neighbor, unsigned short AO)
	{
		Neighbors[nodeId][num]=neighbor;

		CorrespAO[nodeId]=AO; 
	}
	void updateNeighborList(unsigned short nodeId, unsigned short neighbor);
	
	
};

#endif
